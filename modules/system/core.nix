{
  pkgs,
  lib,
  username,
  hostname,
  ...
}:
{

  options = {
    host.is_headless = lib.mkEnableOption "mark system as headless";
  };

  config = {

    networking.hostName = "${hostname}";

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    nix.settings.trusted-users = [ username ];

    # customise /etc/nix/nix.conf declaratively via `nix.settings`
    nix.settings = {
      # enable flakes globally
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # $ nix search wget
    environment.systemPackages = with pkgs; [
      curl
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      git
      nh
    ];
  };
}
