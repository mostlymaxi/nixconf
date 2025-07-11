{ ... }:
{
  imports = [
    ../../home/darwin.nix
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  terminal.kitty.enable = true;

  style.fonts.enable = true;

  programs.enable = true;
}
