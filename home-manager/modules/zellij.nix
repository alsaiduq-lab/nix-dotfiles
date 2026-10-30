{config, ...}: {
  programs.zellij = {
    enable = true;

    settings = {
      theme = "tokyonight_storm";
      theme_dir = "${config.xdg.configHome}/zellij/theme";
    };
  };
}
