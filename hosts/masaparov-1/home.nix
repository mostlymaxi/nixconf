{ coreweave, ... }:
{
  imports = [
    ../../home/default.nix
    coreweave.homeManagerModules.default
  ];

  shell.fish.enable = true;
  shell.default = "fish";

  programs.core.enable = true;

  coreweave.programs.kubernetes.enable = true;
}
