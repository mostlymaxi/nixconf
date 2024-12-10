{pkgs, lib, config, ...}: with lib; {
  options = {
    launcher = mkOption {
      type = types.enum ["fuzzel"];
    };
  };

  config = lib.mkIf (config.launcher == "fuzzel") {
    launchLauncher = "${pkgs.fuzzel}/bin/fuzzel";

    programs.fuzzel = {
      enable = true;

      settings = {
	main = {
	  terminal = "${config.launchTerminal}";
	  font = mkForce "${config.stylix.fonts.monospace.name}:size=20";
	};
      };
    };
  };
}

