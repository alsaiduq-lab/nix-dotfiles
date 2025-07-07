{pkgs, ...}: let
  modernx = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/cyl0/ModernX/0.6.1/modernx.lua";
    sha256 = "11n7qqaj2f3l53wg7vqdf007zky45nkviwy10xmb9kxwddnpmxsm";
  };

  modernxFont = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/cyl0/ModernX/0.6.1/Material-Design-Iconic-Font.ttf";
    sha256 = "06nsghfgsvhqfcvfd9k1dp3mvh5xz0cz5k5vqcby4v5nxki5p90q";
  };
in {
  home.packages = with pkgs; [
    mpv
    mpvScripts.thumbfast
  ];

  home.file.".config/mpv/mpv.conf".text = ''
    profile=gpu-hq
    osc=no
    border=no
    script=~~/scripts/modernx.lua
    script=~~/scripts/thumbfast.lua
    script-opts=modernx-theme=Nordic
    sub-font="Noto Sans"
    sub-font-size=40
  '';

  home.file.".config/mpv/scripts/modernx.lua".source =
    modernx;

  home.file.".config/mpv/scripts/thumbfast.lua".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua";

  home.file.".config/mpv/script-opts/thumbfast.conf".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/script-opts/thumbfast.conf";

  home.file.".config/mpv/fonts/Material-Design-Iconic-Font.ttf".source =
    modernxFont;
}
