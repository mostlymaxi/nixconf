{ ... }:
{
  imports = [
    ../../home
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  terminal.foot.enable = true;
  terminal.default = "foot";

  style.fonts.enable = true;

  programs.enable = true;
}
