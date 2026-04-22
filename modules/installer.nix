{ lib, ... }:
{
  networking.hostName = "nixos-installer";

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDrwB1o6SQRY7DlJ2JxPw9dedIkbZBCnzpd777RQW3hCAAAABHNzaDo="
  ];

  # broadcast nixos-installer.local via mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  networking.useDHCP = lib.mkForce true;
  networking.networkmanager.enable = lib.mkForce false;
}
