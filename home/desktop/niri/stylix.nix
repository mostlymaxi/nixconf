{lib, ...}: with lib; {
  config = mkIf (config.stylix.enable && config.stylix.targets.niri.enable) {
    programs.niri.settings = {
      cursor.size = mkDefault config.stylix.cursor.size;
      cursor.theme = mkDefault config.stylix.cursor.name;
      layout.focus-ring.enable = mkDefault false;
      layout.border = with config.lib.stylix.colors.withHashtag; {
	enable = mkDefault true;
	active.gradient = mkDefault {
	  from = base0D;
	  to = base0E;
	};
	inactive = mkDefault {color = base03;};
      };
    };
  };
}
