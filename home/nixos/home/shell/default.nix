{lib, config, ...}: with lib; {
  imports = [./fish];

  options = {
    shell = mkOption {
      type = types.enum [];
    };

    launchShell = mkOption {
      type = types.str;
    };

    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = {
	ls = "ls -la";
        greeting = "";
        please = "sudo";
      };
    };
  };

  config = {
    shellAliases = mkIf config.programs.enable {
      ls = "exa -la";
      cat = "bat";
      greeting = "fastfetch";
      please = "sudo";
    };
  };
}
