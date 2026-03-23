{ pkgs, ... }:

let
  neovim-power-mode = pkgs.vimUtils.buildVimPlugin {
    name = "neovim-power-mode";
    src = pkgs.fetchFromGitHub {
      owner = "axsaucedo";
      repo = "neovim-power-mode";
      rev = "1a62ecd662f5c7d8ce71c9c47a3fe04414431124";
      sha256 = "sha256-ojDevwmNRFtWJMN69OFIKyC839DAHQNmhb89I0zy3dY=";
    };
  };
in
{
  programs.nixvim = {
    extraPlugins = [
      neovim-power-mode
    ];

    extraConfigLua = ''
      require("power-mode").setup({
        particles = { preset = "explosion" },
        combo = { enabled = false },
        shake = { mode = "none" },
      })
    '';
  };
}
