{ ... }:
{
  imports = [
    ../../home/darwin.nix
  ];

  shell.fish.enable = true;
  shell.nu.enable = true;
  shell.default = "fish";

  terminal.kitty.enable = true;
  terminal.ghostty.enable = true;
  terminal.default = "ghostty";

  style.enable = true;

  programs.enable = true;
}
