{
  programs.nixvim = {
    plugins.markdown-preview = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>tm";
        action = "<cmd>MarkdownPreviewToggle<CR>";
        options = {
          desc = "[T]oggle [M]arkdown preview";
        };
      }
    ];
  };
}
