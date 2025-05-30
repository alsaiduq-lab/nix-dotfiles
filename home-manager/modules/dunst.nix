{pkgs, ...}: let
  urgencyLowBackground = "#1a1b26";
  urgencyLowForeground = "#c0caf5";
  urgencyLowFrameColor = "#7aa2f7";
  urgencyNormalBackground = "#24283b";
  urgencyNormalForeground = "#c0caf5";
  urgencyNormalFrameColor = "#7aa2f7";
  urgencyCriticalBackground = "#f7768e";
  urgencyCriticalForeground = "#1a1b26";
  urgencyCriticalFrameColor = "#ff757f";

  volumeHighlight = "#f5c2e7";
  volumeFrameColor = "#eba0ac";
  volumeBackground = "#45475a";
  volumeForeground = "#f5e0dc";

  brightnessHighlight = "#94e2d5";
  brightnessFrameColor = "#74c7ec";
  brightnessBackground = "#313244";
  brightnessForeground = "#a6e3a1";

  networkHighlight = "#f9e2af";
  networkFrameColor = "#f38ba8";
  networkBackground = "#1e1e2e";
  networkForeground = "#fab387";

  globalFrameColor = "#7aa2f7";
  globalCornerRadius = 10;
  globalMargin = 8;
  globalPadding = 12;
  globalBorderWidth = 2;
  globalFont = "0xProto Nerd Font Bold 10";
  globalIconPath = "/usr/share/icons/Candy/16x16/status/:/usr/share/icons/Candy/16x16/devices/:/usr/share/icons/Candy/16x16/apps/";
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "(300, 400)";
        height = 300;
        origin = "top-right";
        offset = "15x50";
        scale = 0;
        notification_limit = 0;

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        transparency = 5;
        padding = globalPadding;
        horizontal_padding = globalPadding;
        text_icon_padding = 12;
        frame_width = globalBorderWidth;
        frame_color = globalFrameColor;
        separator_color = "frame";
        separator_height = 2;
        corner_radius = globalCornerRadius;
        gap_size = globalMargin;
        line_height = 0;

        font = globalFont;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        enable_recursive_icon_lookup = true;
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        icon_path = globalIconPath;

        sticky_history = "yes";
        history_length = 20;

        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      urgency_low = {
        background = urgencyLowBackground;
        foreground = urgencyLowForeground;
        frame_color = urgencyLowFrameColor;
        timeout = 5;
      };

      urgency_normal = {
        background = urgencyNormalBackground;
        foreground = urgencyNormalForeground;
        frame_color = urgencyNormalFrameColor;
        timeout = 5;
      };

      urgency_critical = {
        background = urgencyCriticalBackground;
        foreground = urgencyCriticalForeground;
        frame_color = urgencyCriticalFrameColor;
        timeout = 0;
      };

      volume = {
        appname = "Volume";
        summary = "*";
        format = "<b>%s</b>\n%b";
        highlight = volumeHighlight;
        frame_color = volumeFrameColor;
        background = volumeBackground;
        foreground = volumeForeground;
      };
      brightness = {
        appname = "Brightness";
        summary = "*";
        format = "<b>%s</b>\n%b";
        highlight = brightnessHighlight;
        frame_color = brightnessFrameColor;
        background = brightnessBackground;
        foreground = brightnessForeground;
      };
      network = {
        appname = "Network";
        summary = "*";
        format = "<b>%s</b>\n%b";
        highlight = networkHighlight;
        frame_color = networkFrameColor;
        background = networkBackground;
        foreground = networkForeground;
      };
    };
  };

  home.packages = with pkgs; [
    dunst
  ];
}
