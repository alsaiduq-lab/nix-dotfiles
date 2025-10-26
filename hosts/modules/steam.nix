{pkgs, ...}: {
  programs.steam = {
    enable = true;
    # apparently enabling this makes big picture boot up, does not work on nvidia however
    # gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks
    protontricks
    gamemode
    mangohud
    libstrangle
  ];
}
