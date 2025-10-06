# used to seed my config
{lib, ...}:
with lib; {
  options.theme = {
    user = mkOption {
      type = types.str;
      default = "cobray";
    };
    cursorName = mkOption {
      type = types.str;
      default = "Hu-Tao-Animated-Cursor";
    };
    cursorSize = mkOption {
      type = types.int;
      default = 24;
    };
    gtkTheme = mkOption {
      type = types.str;
      default = "Tokyonight-Dark";
    };
    gtkThemeMode = mkOption {
      type = types.str;
      # light or dark mode
      default = "dark";
    };
    qtTheme = mkOption {
      type = types.str;
      # qt5 or 6 it seems
      default = "qt6ct";
    };
    qtOverride = mkOption {
      type = types.str;
      default = "Fusion";
    };
    iconTheme = mkOption {
      type = types.str;
      default = "candy-icons";
    };
    font = mkOption {
      type = types.str;
      default = "Clear Sans 10";
    };
    Terminal = mkOption {
      type = types.str;
      default = "ghostty";
    };
    TerminalFont = mkOption {
      type = types.str;
      default = "0xProto Nerd Font";
    };
    Browser = mkOption {
      type = types.str;
      default = "thorium";
    };
    Editor = mkOption {
      type = types.str;
      default = "nvim";
    };
    Shell = mkOption {
      type = types.str;
      default = "fish";
    };
  };
}
