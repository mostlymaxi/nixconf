{pkgs, lib, config, ...}: with lib; {
  options = {
    terminal = mkOption {
      type = types.enum ["foot"];
    };
  };

  config = lib.mkIf (config.terminal == "foot") {
    # launchTerminal = "${pkgs.foot}/bin/footclient";
    launchTerminal = "footclient";

    programs.foot = {
      enable = true;

      server.enable = true;

      settings = {
        csd = { preferred = "server"; };

	main = {
	  shell = "${config.launchShell}";
	  term = "xterm-256color";
	  # font = "Cascadia Mono:size=14";
	  # dpi-aware = "yes";
	  pad = "5x0";
	};
	
	mouse = {
	  hide-when-typing = "yes";
	};

# 	colors = {
#  	  alpha = "0.75";
# 	  foreground = "cad3f5"; # Text
# 	  background = "24273a"; # Base
# 	  regular0 = "494d64";   # Surface 1
# 	  regular1 = "ed8796";   # red
# 	  regular2 = "a6da95";   # green
# 	  regular3 = "eed49f";   # yellow
# 	  regular4 = "8aadf4";   # blue
# 	  regular5 = "f5bde6";   # pink
# 	  regular6 = "8bd5ca";   # teal
# 	  regular7 = "b8c0e0";   # Subtext 1
# 	  bright0 = "5b6078";    # Surface 2
# 	  bright1 = "ed8796";    # red
# 	  bright2 = "a6da95";    # green
# 	  bright3 = "eed49f";    # yellow
# 	  bright4 = "8aadf4";    # blue
# 	  bright5 = "f5bde6";    # pink
# 	  bright6 = "8bd5ca";    # teal
# 	  bright7 = "a5adcb";    # Subtext 0 
# 	};
      };

    };
  };
}

