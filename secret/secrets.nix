let
  yubikey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDrwB1o6SQRY7DlJ2JxPw9dedIkbZBCnzpd777RQW3hCAAAABHNzaDo=";

  hosts = map (name: builtins.readFile (./hosts + "/${name}")) (
    builtins.attrNames (builtins.readDir ./hosts)
  );
in
{
  "grafana-api-key.age".publicKeys = hosts;
}
