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

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      curl
      vim
      git
      nh
    ];
  };
}
