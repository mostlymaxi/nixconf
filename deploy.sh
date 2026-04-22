#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_TARGET="nixos-installer.local"
DEFAULT_SYSTEM="x86_64-linux"

usage() {
  cat <<EOF
Usage:
  ./deploy.sh init   <hostname> [target] [system]  — discover hardware + scaffold host config
  ./deploy.sh deploy <hostname> [target]            — install NixOS via nixos-anywhere

Options:
  --no-kexec    skip kexec (required for Pi 3 and other devices that don't support it)

target defaults to $DEFAULT_TARGET (mDNS from installer image)
system defaults to $DEFAULT_SYSTEM
EOF
  exit 1
}

SSH_OPTS=(-o StrictHostKeyChecking=accept-new -o ControlMaster=auto -o "ControlPath=/tmp/deploy-%r@%h" -o ControlPersist=300)

ssh_target() {
  ssh "${SSH_OPTS[@]}" "root@${TARGET}" "$@"
}

scp_from_target() {
  scp "${SSH_OPTS[@]}" "root@${TARGET}:${1}" "${2}"
}

cleanup_ssh() {
  ssh -o "ControlPath=/tmp/deploy-%r@%h" -O exit "root@${TARGET}" 2>/dev/null || true
}
trap cleanup_ssh EXIT

# ── new: discover hardware and scaffold host config ──────────────────────────

cmd_new() {
  local HOSTNAME="${1:?Usage: ./deploy.sh new <hostname> [target] [system]}"
  TARGET="${2:-$DEFAULT_TARGET}"
  local SYSTEM="${3:-$DEFAULT_SYSTEM}"
  local HOST_DIR="${SCRIPT_DIR}/hosts/${HOSTNAME}"

  if [[ -d "$HOST_DIR" ]]; then
    echo "error: hosts/${HOSTNAME}/ already exists"
    exit 1
  fi

  echo "==> Discovering hardware on ${TARGET}..."

  # discover disks
  local DISKS
  DISKS=$(ssh_target "lsblk -d -n -p -o NAME,SIZE,MODEL --exclude 7,11")
  local DISK_COUNT
  DISK_COUNT=$(echo "$DISKS" | wc -l)

  echo ""
  echo "Available disks:"
  echo "$DISKS" | nl -ba
  echo ""

  local DEVICE
  if [[ "$DISK_COUNT" -eq 1 ]]; then
    DEVICE=$(echo "$DISKS" | awk '{print $1}')
    echo "Auto-selected: ${DEVICE}"
  else
    read -rp "Select disk number [1-${DISK_COUNT}]: " DISK_NUM
    DEVICE=$(echo "$DISKS" | sed -n "${DISK_NUM}p" | awk '{print $1}')
  fi

  if [[ -z "$DEVICE" ]]; then
    echo "error: no disk selected"
    exit 1
  fi

  echo ""
  echo "==> Generating hardware config on ${TARGET}..."

  # generate hardware-configuration.nix on target
  # try --no-filesystems first (recent nixpkgs), fall back to stripping manually
  if ! ssh_target "nixos-generate-config --no-filesystems --dir /tmp/hw-config 2>/dev/null"; then
    echo "    (--no-filesystems not available, generating full config and stripping)"
    ssh_target "nixos-generate-config --dir /tmp/hw-config"
  fi

  mkdir -p "$HOST_DIR"

  scp_from_target "/tmp/hw-config/hardware-configuration.nix" "${HOST_DIR}/hardware-configuration.nix"

  # strip fileSystems and swapDevices if present (disko handles these)
  sed -i '/^\s*fileSystems\./,/^\s*};$/d' "${HOST_DIR}/hardware-configuration.nix"
  sed -i '/^\s*swapDevices\s*=/d' "${HOST_DIR}/hardware-configuration.nix"

  # replace hostPlatform with the correct system
  sed -i "s|nixpkgs.hostPlatform = .*|nixpkgs.hostPlatform = lib.mkDefault \"${SYSTEM}\";|" "${HOST_DIR}/hardware-configuration.nix"

  echo "==> Scaffolding hosts/${HOSTNAME}/..."

  # generate disko.nix
  cat > "${HOST_DIR}/disko.nix" <<DISKO
{
  disko.devices.disk.main = {
    type = "disk";
    device = "${DEVICE}";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "fmask=0077" "dmask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
DISKO

  # generate default.nix
  cat > "${HOST_DIR}/default.nix" <<'DEFAULTNIX'
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/system
  ];

  # TODO: configure boot loader
  # EFI:
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # Raspberry Pi / ARM:
  # boot.loader.grub.enable = false;
  # boot.loader.generic-extlinux-compatible.enable = true;

  boot.kexec.enable = true;

  system.stateVersion = "26.05";
}
DEFAULTNIX

  # generate home.nix
  cat > "${HOST_DIR}/home.nix" <<'HOMENIX'
{ ... }:
{
  imports = [ ../../home/default.nix ];

  shell.fish.enable = true;
  shell.default = "fish";

  programs.core.enable = true;
}
HOMENIX

  echo ""
  echo "==> Done! Created hosts/${HOSTNAME}/"
  echo ""
  echo "Next steps:"
  echo "  1. Review and edit the generated files in hosts/${HOSTNAME}/"
  echo "     - default.nix: uncomment the right boot loader, add modules"
  echo "     - disko.nix: verify disk device and partition layout"
  echo "     - hardware-configuration.nix: verify kernel modules"
  echo "     - home.nix: add your preferred terminal, desktop, etc."
  echo "  2. Add to flake.nix nixosConfigurations:"
  echo "       ${HOSTNAME} = mkNixos {"
  echo "         hostname = \"${HOSTNAME}\";"
  echo "         system = \"${SYSTEM}\";"
  echo "       };"
  echo "  3. Test build: nix build .#nixosConfigurations.${HOSTNAME}.config.system.build.toplevel"
  echo "  4. Deploy:     ./deploy.sh deploy ${HOSTNAME} ${TARGET}"
}

# ── deploy: install NixOS via nixos-anywhere ─────────────────────────────────

cmd_deploy() {
  local NO_KEXEC=false
  local args=()
  for arg in "$@"; do
    case "$arg" in
      --no-kexec) NO_KEXEC=true ;;
      *) args+=("$arg") ;;
    esac
  done

  local HOSTNAME="${args[0]:?Usage: ./deploy.sh deploy <hostname> [target] [--no-kexec]}"
  TARGET="${args[1]:-$DEFAULT_TARGET}"

  echo "Deploying ${HOSTNAME} to ${TARGET}..."
  echo "WARNING: This will ERASE ALL DATA on the target's configured disk."
  echo ""
  read -rp "Continue? [y/N] " -n 1
  echo ""
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1

  local extra_args=()
  if [[ "$NO_KEXEC" == true ]]; then
    extra_args+=(--phases "disko,install")
    echo "NOTE: skipping kexec, using target's existing installer environment."
    echo "      Manually power cycle the target after install completes."
  fi

  nix run github:nix-community/nixos-anywhere -- \
    --flake "${SCRIPT_DIR}#${HOSTNAME}" \
    --target-host "root@${TARGET}" \
    "${extra_args[@]}"
}

# ── main ─────────────────────────────────────────────────────────────────────

case "${1:-}" in
  init)   shift; cmd_new "$@" ;;
  deploy) shift; cmd_deploy "$@" ;;
  *)      usage ;;
esac
