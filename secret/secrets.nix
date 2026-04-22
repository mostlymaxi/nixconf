let
  yubikey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDrwB1o6SQRY7DlJ2JxPw9dedIkbZBCnzpd777RQW3hCAAAABHNzaDo=";

  # After first deploy, get host keys with: ssh-keyscan <host-ip>
  # pickle = "ssh-ed25519 AAAA...";
  # blueberry = "ssh-ed25519 AAAA...";
in
{
  # Example:
  # "grafana-api-key.age".publicKeys = [ yubikey pickle ];
}
