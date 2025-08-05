{ coreweave, ... }:
{
  imports = [
    ../../home/darwin.nix
    coreweave.homeManagerModules.default
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  terminal.kitty.enable = true;

  style.fonts.enable = true;

  programs.enable = true;

  coreweave.programs.kubernetes.enable = true;
}
