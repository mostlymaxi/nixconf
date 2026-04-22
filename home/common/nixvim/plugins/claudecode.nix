{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.claude-code = {
      enable = true;
      settings = { };
    };
  };
}