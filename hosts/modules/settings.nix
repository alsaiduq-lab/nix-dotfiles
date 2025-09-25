{lib, ...}:
with lib; {
  options.theme = {
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
    iconTheme = mkOption {
      type = types.str;
      default = "candy-icons";
    };
    fontName = mkOption {
      type = types.str;
      default = "Clear Sans 10";
    };
  };
}
