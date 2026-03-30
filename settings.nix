# used to seed my config
{lib, ...}: let
  mkStr = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
  mkInt = default:
    lib.mkOption {
      type = lib.types.int;
      inherit default;
    };
in {
  options.theme = {
    user = mkStr "hibiki";
    cursorName = mkStr "Hatsune Miku Colorful Stage";
    cursorSize = mkInt 40;
    gtkTheme = mkStr "Tokyonight-Dark";
    gtkThemeMode = mkStr "dark";
    qtTheme = mkStr "qt6ct";
    qtOverride = mkStr "Fusion";
    iconTheme = mkStr "candy-icons";
    font = mkStr "Clear Sans 12";
    Terminal = mkStr "ghostty";
    TerminalFont = mkStr "0xProto Nerd Font";
    Browser = mkStr "thorium-browser";
    Editor = mkStr "nvim";
    Shell = mkStr "fish";
  };
}
