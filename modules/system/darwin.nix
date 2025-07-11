{
  username,
  ...
}:
{

  imports = [ ./core.nix ];

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  nix.linux-builder.enable = true;

  nix.linux-builder = {
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 80 * 1024;
          memorySize = 16 * 1024;
        };
        cores = 6;
      };
    };
  };

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

}
