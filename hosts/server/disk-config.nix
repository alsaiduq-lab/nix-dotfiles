{lib, ...}: {
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = "/dev/xvda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            mbr = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };
          };
        };
      };
      main = {
        type = "disk";
        device = "/dev/xvdb";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/home" = {
    device = "/dev/data/home";
    fsType = "ext4";
  };
}
