{ ... }:
{
  imports = [
    ../../home
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  launcher.default = "fuzzel";

  terminal.ghostty.enable = true;
  terminal.default = "ghostty";

  pretty.enable = true;

  programs.enable = true;
  games.enable = true;
}
