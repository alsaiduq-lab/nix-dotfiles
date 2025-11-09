{pkgs, ...}: let
  modernx = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/cyl0/ModernX/0.6.1/modernx.lua";
    sha256 = "11n7qqaj2f3l53wg7vqdf007zky45nkviwy10xmb9kxwddnpmxsm";
  };
  modernxFont = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/cyl0/ModernX/0.6.1/Material-Design-Iconic-Font.ttf";
    sha256 = "06nsghfgsvhqfcvfd9k1dp3mvh5xz0cz5k5vqcby4v5nxki5p90q";
  };
  anime4k = pkgs.fetchFromGitHub {
    owner = "bloc97";
    repo = "Anime4K";
    rev = "v4.0.1";
    sha256 = "sha256-OQWJWcDpwmnJJ/kc4uEReaO74dYFlxNQwf33E5Oagb0=";
  };
in {
  home.packages = with pkgs; [
    mpv
    mpvpaper
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
    hwdec=nvdec
    hwdec-codecs=all
    glsl-shaders="~~/shaders/Restore/Anime4K_Clamp_Highlights.glsl:~~/shaders/Restore/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Upscale/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Upscale/Anime4K_Upscale_CNN_x2_M.glsl"
  '';
  home.file.".config/mpv/input.conf".text = ''
    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "Shaders cleared"
    CTRL+1 no-osd change-list glsl-shaders set "~~/shaders/Restore/Anime4K_Clamp_Highlights.glsl:~~/shaders/Restore/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Upscale/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Upscale/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"
    CTRL+2 no-osd change-list glsl-shaders set "~~/shaders/Restore/Anime4K_Clamp_Highlights.glsl:~~/shaders/Upscale+Denoise/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Upscale/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Upscale/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (Denoise - for artifact-heavy anime)"
  '';
  home.file.".config/mpv/scripts/modernx.lua".source = modernx;
  home.file.".config/mpv/scripts/thumbfast.lua".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua";
  home.file.".config/mpv/script-opts/thumbfast.conf".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/script-opts/thumbfast.conf";
  home.file.".config/mpv/fonts/Material-Design-Iconic-Font.ttf".source = modernxFont;
  home.file.".config/mpv/shaders".source = "${anime4k}/glsl";
}
