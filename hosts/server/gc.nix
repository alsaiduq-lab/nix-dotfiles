{lib, ...}: {
  nix.gc = {
    automatic = true;
    dates = lib.mkForce "*-*-* 03:00:00";
    options = "--delete-older-than 7d";
    persistent = false;
  };

  systemd.services.nix-gc.serviceConfig = {
    Nice = 19;
    IOSchedulingClass = "idle";
  };
}
