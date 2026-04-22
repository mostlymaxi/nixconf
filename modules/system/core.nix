{
  pkgs,
  username,
  hostname,
  ...
}:
{

  networking.hostName = "${hostname}";

  nix.settings = {
    trusted-users = [ username ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    git
    nh
  ];
}
