{lib, config, ...}: with lib; {
  config = mkIf (config.stylix.enable) {

    programs.niri.settings = {
      cursor.size = mkDefault config.stylix.cursor.size;
      cursor.theme = mkDefault config.stylix.cursor.name;
      layout.focus-ring.enable = mkDefault false;
      layout.border = with config.lib.stylix.colors.withHashtag; {
	enable = mkDefault true;
	active.gradient = mkDefault {
	  from = base08;
	  to = base0D;
	  angle = 45;
	};
	inactive = mkDefault {color = base03;};
      };
    };
  };
}
