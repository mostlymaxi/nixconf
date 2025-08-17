{
  hostname,
  username,
  lib,
  ...
}:
{
  imports = [ ../../modules/system/darwin.nix ];

  networking.hostName = "${hostname}";

  nix.enable = lib.mkForce true;

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
    defaults = {
      CustomUserPreferences = {
        # Avoid creating .DS_Store files on network or USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

      };
      # Show hidden files in Finder
      finder = {
        AppleShowAllFiles = true;
      };

      dock = {
        mineffect = "scale";
        autohide = false;
      };

      trackpad = {
        Clicking = true;
      };

      # Disable "Natural" scrolling direction
      NSGlobalDomain."com.apple.swipescrolldirection" = false;
    };

    primaryUser = "${username}";
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # annoying MacOS stuff
  # this needs to be enabled both here AND in home-manager
  programs.fish.enable = true;

  # Enables TouchID for sudo operations
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    # install apps from the Mac App Store
    masApps = { };

    brews = [ ];

    casks = [
      "kitty"
      "docker"
    ];

    enable = true;
    global.autoUpdate = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    # remove all Homebrew packages and casks not managed by nix-darwin
    onActivation.cleanup = "zap";
  };
}
