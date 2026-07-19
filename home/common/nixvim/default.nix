{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    # Plugins
    ./plugins/gitsigns.nix
    ./plugins/which-key.nix
    ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
    ./plugins/mini.nix
    ./plugins/treesitter.nix
    ./plugins/colorizer.nix
    ./plugins/oil.nix
    ./plugins/rustaceanvim.nix
    ./plugins/lazygit.nix
    ./plugins/smear-cursor.nix
    ./plugins/snacks.nix
    ./plugins/opencode.nix
    ./plugins/claudecode.nix

    ./plugins/custom/eldritch-theme.nix
    ./plugins/custom/neovim-power-mode.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    nixpkgs.useGlobalPackages = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = config.style.fonts.enable;
    };

    opts = {
      termguicolors = true;
      number = true;
      mouse = "a";

      showmode = false;

      clipboard = {
        providers = {
          wl-copy.enable = true; # For Wayland
          xsel.enable = false; # For X11
        };
      };

      breakindent = true;
      undofile = true;

      ignorecase = true;
      smartcase = true;

      signcolumn = "yes";

      updatetime = 250;
      timeoutlen = 300;

      splitright = true;
      splitbelow = true;

      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      hlsearch = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit terminal mode";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-h>";
        action = "<C-\\><C-n><C-w><C-h>";
        options = {
          desc = "Move focus to the left window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-l>";
        action = "<C-\\><C-n><C-w><C-l>";
        options = {
          desc = "Move focus to the right window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-j>";
        action = "<C-\\><C-n><C-w><C-j>";
        options = {
          desc = "Move focus to the lower window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-k>";
        action = "<C-\\><C-n><C-w><C-k>";
        options = {
          desc = "Move focus to the upper window";
        };
      }
    ];

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "lazygit" ];
        desc = "Pass ctrl+j/k through to lazygit (move commits) instead of window navigation";
        callback.__raw = ''
          function(ev)
            -- buffer-local noremap to the key itself shadows the global
            -- terminal-mode window-nav maps and sends the key to lazygit
            vim.keymap.set("t", "<C-j>", "<C-j>", { buffer = ev.buf })
            vim.keymap.set("t", "<C-k>", "<C-k>", { buffer = ev.buf })
          end
        '';
      }
      {
        event = [ "TextYankPost" ];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    plugins = {
      web-devicons.enable = true;

      sleuth.enable = true;

      todo-comments = {
        settings = {
          enable = true;
          signs = true;
        };
      };
    };

    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
    '';

    extraConfigLuaPost = "";
  };
}
