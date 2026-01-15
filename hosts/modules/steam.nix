{pkgs, ...}: {
  programs.steam = {
    enable = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.proton-cachyos
      pkgs.dw-proton
    ];
    # for hosting
    # dedicatedServer.openFirewall = true;
    # remotePlay.openFirewall = true;
    extest.enable = true;
    protontricks.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode on'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode off'";
      };
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    wine-tkg
    winetricks
    mangohud
    libstrangle
    gamescope-wsi
    ipc-bridge
    umu-launcher
  ];
}
