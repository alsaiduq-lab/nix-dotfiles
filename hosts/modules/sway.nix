{
  pkgs,
  wallpaperDir ? "/home/cobray/wallpapers",
  ...
}: let
  randomWallpaper = pkgs.writeShellScript "wallpaper.sh" ''
    #!${pkgs.runtimeShell}
    set -e
    BG_DIR="/var/lib/lightdm-background"
    BG_LINK="$BG_DIR/random-wallpaper.png"
    LAST="$BG_DIR/.last-wallpaper"
    mkdir -p "$BG_DIR"
    mapfile -t WALLPAPERS < <(${pkgs.findutils}/bin/find '${wallpaperDir}' -type f -iregex '.*\.\(png\|jpe\?g\)') || true
    if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
      cp '${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png' "$BG_LINK"
    else
      cp "''${WALLPAPERS[$(${pkgs.coreutils}/bin/shuf -i0-$((''${#WALLPAPERS[@]}-1)) -n1)]}" "$BG_LINK"
    fi
    echo "$BG_LINK" > "$LAST"
    chown lightdm:lightdm "$BG_LINK" "$LAST"
  '';
in {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config.output."*".bg = "/var/lib/lightdm-background/random-wallpaper.png fill";
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.sway}/bin/sway";
    settings.default_session.user = "cobray";
  };

  services.xserver.enable = false;
  services.displayManager.lightdm.enable = false;

  systemd.services.random-wallpaper = {
    description = "Pick daily background";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = randomWallpaper;
    };
  };
  systemd.timers.random-wallpaper = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "daily";
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/lightdm-background 0755 lightdm lightdm - -"
    "d ${wallpaperDir}              0755 cobray   users   - -"
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark";
    };
    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    waybar
    swaylock
    swayidle
    wl-clipboard
    grim
    slurp
    mako
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
}
