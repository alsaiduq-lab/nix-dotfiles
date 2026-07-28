{inputs}: {
  desktop = {
    settings = {
      user = "hibiki";
      cursorName = "Hatsune Miku Colorful Stage";
      cursorSize = 40;
      gtkTheme = "Tokyonight-Dark";
      gtkThemeMode = "dark";
      qtTheme = "qt6ct";
      qtOverride = "Fusion";
      iconTheme = "Magna-Glassy-Dark-Icons";
      font = "Clear Sans 12";
      Terminal = "ghostty";
      TerminalFont = "0xProto Nerd Font";
      Browser = "thorium-browser";
      Editor = "zeditor";
      Shell = "fish";
    };
  };

  laptop = {
    settings = {
      user = "monaie";
      cursorName = "Hatsune Miku Colorful Stage";
      cursorSize = 24;
      gtkTheme = "Tokyonight-Dark";
      gtkThemeMode = "dark";
      qtTheme = "qt6ct";
      qtOverride = "Fusion";
      iconTheme = "Magna-Glassy-Dark-Icons";
      font = "Clear Sans 12";
      Terminal = "ghostty";
      TerminalFont = "0xProto Nerd Font";
      Browser = "thorium-browser";
      Editor = "zeditor";
      Shell = "fish";
    };
  };

  server = {
    settings = {
      user = "alteur";
      hostname = "monaie.ca";
      port = 8123;
    };
  };

  dotfiles = {
    tokyo-storm-fish-theme = {
      from = "${inputs.tokyo-night}/extras/fish/tokyonight_storm.fish";
      to = "fish/conf.d/tokyonight_storm.fish";
    };

    tokyo-storm-btop-theme = {
      from = "${inputs.tokyo-night}/extras/btop/tokyonight_storm.theme";
      to = "btop/themes/tokyonight_storm.theme";
    };

    eza-theme = {
      from = "${inputs.tokyo-night}/extras/eza/tokyonight_moon.yml";
      to = "eza/theme.yml";
    };

    yazi-theme = {
      from = "${inputs.tokyo-night}/extras/yazi/tokyonight_storm.toml";
      to = "yazi/theme.toml";
    };

    zellij-theme = {
      from = "${inputs.tokyo-night}/extras/zellij/tokyonight_moon.kdl";
      to = "zellij/theme/tokyonight_moon.kdl";
    };

    modernx = {
      from = "${inputs.modernx}";
      to = "mpv/";

      files = {
        "modernx.lua" = "scripts/modernx.lua";
        "Material-Design-Iconic-Font.ttf" = "fonts/Material-Design-Iconic-Font.ttf";
      };
    };

    anime4k = {
      from = "${inputs.anime4k}/glsl/";
      to = "mpv/shaders/";
    };

    hypr-scripts = {
      from = "../config/scripts/";
      to = "hypr/scripts/";
    };
  };
}
