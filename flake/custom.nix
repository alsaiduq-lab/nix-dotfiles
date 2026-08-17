{inputs}: {
  desktop = {
    settings = {
      user = "hibiki";
      cursorName = "Hoshimi Miyabi Cursor";
      cursorSize = 40;
      gtkTheme = "Tokyonight-Dark-Storm";
      iconTheme = "Magna-Glassy-Dark-Icons";
      font = "Clear Sans 12";
      Terminal = "ghostty";
      TerminalFont = "0xProto Nerd Font";
      Browser = "thorium-browser";
      Editor = "nvim";
      Shell = "fish";
    };
  };

  laptop = {
    settings = {
      user = "monaie";
      cursorName = "Hatsune-Miku-Colorful-Stage";
      cursorSize = 24;
      gtkTheme = "Tokyonight-Dark-Storm";
      iconTheme = "Magna-Glassy-Dark-Icons";
      font = "Clear Sans 12";
      Terminal = "ghostty";
      TerminalFont = "0xProto Nerd Font";
      Browser = "thorium-browser";
      Editor = "nvim";
      Shell = "fish";
    };
  };

  server = {
    settings = {
      user = "alteur";
      domain = "monaie.ca";
      port = 8123;
      Editor = "nvim";
      Shell = "fish";
      TerminalFont = "0xProto Nerd Font";
    };
  };

  dotfiles = {
    tokyo-storm-fish-theme = {
      from = "${inputs.tokyo-night}/extras/fish/tokyonight_storm.fish";
      final = "fish/conf.d/tokyonight_storm.fish";
    };

    tokyo-storm-btop-theme = {
      from = "${inputs.tokyo-night}/extras/btop/tokyonight_storm.theme";
      final = "btop/themes/tokyonight_storm.theme";
    };

    eza-theme = {
      from = "${inputs.tokyo-night}/extras/eza/tokyonight_moon.yml";
      final = "eza/theme.yml";
    };

    yazi-theme = {
      from = "${inputs.tokyo-night}/extras/yazi/tokyonight_storm.toml";
      final = "yazi/theme.toml";
    };

    zellij-theme = {
      from = "${inputs.tokyo-night}/extras/zellij/tokyonight_moon.kdl";
      final = "zellij/theme/tokyonight_moon.kdl";
    };

    modernx = {
      from = "${inputs.modernx}";
      final = "mpv/";

      files = {
        "modernx.lua" = "scripts/modernx.lua";
        "Material-Design-Iconic-Font.ttf" = "fonts/Material-Design-Iconic-Font.ttf";
      };
    };

    anime4k = {
      from = "${inputs.anime4k}/glsl/";
      final = "mpv/shaders/Anime4K/";
    };

    hypr-scripts = {
      from = "../config/scripts/";
      final = "hypr/scripts/";
    };
  };
}
