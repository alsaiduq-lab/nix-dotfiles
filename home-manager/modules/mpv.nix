{pkgs, ...}: {
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      thumbfast
      webtorrent-mpv-hook
    ];

    scriptOpts = {
      thumbfast = {
        max_height = 200;
        max_width = 200;
        spawn_first = true;
        tone_mapping = "auto"; # "clip", "hable"
        network = true;
      };
      webtorrent = {
        path = "/tmp/vids";
      };
    };

    config = {
      profile = "gpu-hq";
      vo = "gpu-next";
      osc = "no";
      border = "no";
      hwdec = "nvdec";
      "hwdec-codecs" = "all";
      sub-font = "Noto Sans";
      sub-font-size = 40;
    };
  };

  # note they can vary depending on how old and destroyed the material is.
  # I found the best results with anime from ~2006-2012ish; anything else will vary
  home.file.".config/mpv/input.conf".text = ''
    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "Shaders cleared"
    CTRL+1 no-osd change-list glsl-shaders set "~~/shaders/Anime4K/Restore/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K/Restore/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K/Upscale/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K/Upscale/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K/Upscale/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K/Upscale/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"
    CTRL+2 no-osd change-list glsl-shaders set "~~/shaders/Anime4K/Restore/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K/Upscale+Denoise/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K/Upscale/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K/Upscale/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K/Upscale/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (Denoise)"
  '';
}
