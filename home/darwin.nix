{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
  };

  # home-manager's fish module defaults this to true (for apropos-based
  # completions), but it has no effect on darwin where programs.man.package
  # defaults to null and the system man is used instead
  programs.man.generateCaches = false;

  imports = [ ./core.nix ];
}
