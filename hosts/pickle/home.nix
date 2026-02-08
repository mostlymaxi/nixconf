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

  pretty.enable = true;

  programs.enable = true;
}
