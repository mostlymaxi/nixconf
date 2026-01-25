{
  pkgs,
  config,
  lib,
  specialArgs,
  ...
}:
with lib;
{

  # this option is an enum because we only
  # want one greeter enabled at a time.
  # enforcing this with asserts would get
  # very annoying as we add more greeters.
  options = {
    greeter = mkOption {
      type = types.enum [ "tuigreet" ];
    };
  };

  config = mkIf (config.greeter == "tuigreet") {
    boot.kernelParams = [
      "vt.cur_default=0x800F10" # set cursor to white-ish solid block
    ];

    services = {
      xserver.enable = false;

      greetd = {
        enable = true;
        useTextGreeter = true;

        settings = {
          initial_session = {
            user = specialArgs.username;
            # command = "$HOME/.wayland-session";
            command = "${config.initial-session}";
          };

          default_session = {
            user = "greeter";
            command = "${pkgs.tuigreet}/bin/tuigreet" + " -t -r --asterisks";
            # + " --theme 'border=magenta;text=cyan;prompt=cyan'"
            # + " --cmd $HOME/.wayland-session";
          };
        };
      };
    };
  };
}
