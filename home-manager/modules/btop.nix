{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {cudaSupport = true;};

    settings = {
      color_theme = "tokyonight_storm";
      theme_background = false;
      vim_keys = true;
      proc_tree = true;
    };
  };
}
