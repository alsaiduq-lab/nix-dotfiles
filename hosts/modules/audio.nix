{
  lib,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  systemd.user.services.headset-connect = {
    description = "Connect headset";
    wants = ["wireplumber.service"];
    after = ["wireplumber.service"];
    wantedBy = ["graphical-session.target"];
    startLimitIntervalSec = 0;

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = [
        "${lib.getExe' pkgs.bluez "bluetoothctl"} power on"
        "-${lib.getExe' pkgs.bluez "bluetoothctl"} --timeout 5 disconnect 20:AF:1B:34:F9:C7 hfp-hf"
      ];
      ExecStart = "${lib.getExe' pkgs.bluez "bluetoothctl"} --timeout 10 connect 20:AF:1B:34:F9:C7 a2dp-sink";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStartSec = 15;
    };
  };

  # TODO: enable back once i get out of my lazy ass and find the USB dongle for this
  # systemd.user.services.arctis-manager = {
  #  description = "Linux Arctis Manager";
  #  wantedBy = ["default.target"];
  #  wants = ["pipewire-pulse.service"];
  #  after = ["pipewire-pulse.service"];
  #  unitConfig = {
  #    StartLimitIntervalSec = 60;
  #    StartLimitBurst = 5;
  #  };
  #  serviceConfig = {
  #    Type = "simple";
  #    ExecStart = lib.getExe' pkgs.linux-arctis-manager "lam-daemon";
  #    Restart = "on-failure";
  #    RestartSec = 5;
  #  };
  # };

  # services.udev.packages = with pkgs; [
  #  linux-arctis-manager
  # ];

  environment.systemPackages = with pkgs; [
    pipewire
    alsa-utils
    pavucontrol
    pulseaudio
    headsetcontrol
    # linux-arctis-manager
  ];
}
