{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
  };

  imports = [ ./core.nix ];
}
