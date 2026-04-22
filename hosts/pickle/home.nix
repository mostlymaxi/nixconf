{ ... }:
{
  imports = [
    ../../home
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  launcher.default = "fuzzel";

  terminal.foot.enable = true;
  terminal.default = "foot";

  style.enable = true;

  programs.enable = true;
  games.enable = true;
}
