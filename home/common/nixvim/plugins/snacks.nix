{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;

      settings = {
        scroll.enabled = true;
        input.enabled = true;
        picker.enabled = true;
        terminal.enabled = true;
      };
    };
  };
}
