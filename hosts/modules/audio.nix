{
  lib,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire."92-bluetooth" = {
      "context.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
  };

  systemd.user.services.headset-connect = {
    description = "Connect headset";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "headset-connect" ''
        for _ in $(seq 1 15); do
          ${lib.getExe' pkgs.bluez "bluetoothctl"} power on >/dev/null 2>&1 || true
          if ${lib.getExe' pkgs.bluez "bluetoothctl"} connect 20:AF:1B:34:F9:C7; then
            exit 0
          fi
          sleep 1
        done
        exit 1
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    pipewire
    alsa-utils
    pavucontrol
    headsetcontrol
  ];
}
