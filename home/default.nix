{
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  imports = [ ./core.nix ];

}
