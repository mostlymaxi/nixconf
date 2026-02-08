{
  username,
  hostname,
  ...
}:
{

  imports = [ ./core.nix ];

  users.users.${username} = {
    isNormalUser = true;
    description = "i was here";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDrwB1o6SQRY7DlJ2JxPw9dedIkbZBCnzpd777RQW3hCAAAABHNzaDo="
    ];
  };

  virtualisation.docker.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  services.fail2ban.enable = false; # disabling until i figure out how to configure this to be less strict

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
