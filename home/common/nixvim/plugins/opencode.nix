{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.opencode = {
      enable = true;
      settings = {
        provider = {
          enabled = "terminal";
        };
      };
    };

    keymaps = [
      # Ask opencode (normal and visual mode)
      {
        mode = [
          "n"
          "x"
        ];
        key = "<C-a>";
        action.__raw = "function() require('opencode').ask('@this: ', { submit = true }) end";
        options = {
          desc = "Ask opencode…";
        };
      }
      # Execute opencode action (normal and visual mode)
      {
        mode = [
          "n"
          "x"
        ];
        key = "<C-x>";
        action.__raw = "function() require('opencode').select() end";
        options = {
          desc = "Execute opencode action…";
        };
      }
      # Toggle opencode (normal and terminal mode)
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-.>";
        action.__raw = "function() require('opencode').toggle() end";
        options = {
          desc = "Toggle opencode";
        };
      }
      # Add range to opencode (operator, normal and visual mode)
      {
        mode = [
          "n"
          "x"
        ];
        key = "go";
        action.__raw = "function() return require('opencode').operator('@this ') end";
        options = {
          desc = "Add range to opencode";
          expr = true;
        };
      }
      # Add line to opencode (normal mode)
      {
        mode = "n";
        key = "goo";
        action.__raw = "function() return require('opencode').operator('@this ') .. '_' end";
        options = {
          desc = "Add line to opencode";
          expr = true;
        };
      }
      # Scroll opencode up (normal mode)
      {
        mode = "n";
        key = "<S-C-u>";
        action.__raw = "function() require('opencode').command('session.half.page.up') end";
        options = {
          desc = "Scroll opencode up";
        };
      }
      # Scroll opencode down (normal mode)
      {
        mode = "n";
        key = "<S-C-d>";
        action.__raw = "function() require('opencode').command('session.half.page.down') end";
        options = {
          desc = "Scroll opencode down";
        };
      }
      # Increment under cursor (remap + to <C-a>)
      {
        mode = "n";
        key = "+";
        action = "<C-a>";
        options = {
          desc = "Increment under cursor";
          noremap = true;
        };
      }
      # Decrement under cursor (remap - to <C-x>)
      {
        mode = "n";
        key = "-";
        action = "<C-x>";
        options = {
          desc = "Decrement under cursor";
          noremap = true;
        };
      }
    ];
  };

  home.packages = with pkgs; [
    lsof
  ];
}
