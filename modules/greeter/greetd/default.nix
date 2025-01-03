{lib, config, pkgs, specialArgs, ...}: with lib; {

  # this option is an enum because we only
  # want one greeter enabled at a time.
  # enforcing this with asserts would get
  # very annoying as we add more greeters.
  options = {
    greeter = mkOption {
      type = types.enum ["greetd"];
    };
  };

  config = mkIf (config.greeter == "greetd") {
    services = {
      xserver.enable = false;

      greetd = {
	enable = true;

	settings = {
	  initial_session = {
	    user = specialArgs.username;
	    # command = "$HOME/.wayland-session";
	    command = "${config.initial-session}";
	  };

	  default_session = {
	    user = "greeter";
	    command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${config.initial-session}";
	  };
	};
      };
    };

    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
