{ ... }:
{
  imports = [
    ../../home/default.nix
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  programs.core.enable = true;
}
