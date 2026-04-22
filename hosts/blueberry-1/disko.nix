{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/mmcblk0";
    content = {
      type = "table";
      format = "msdos";
      partitions = [
        {
          name = "boot";
          start = "0";
          end = "512MiB";
          fs-type = "fat32";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "root";
          start = "512MiB";
          end = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  };
}
