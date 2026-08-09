{
  pkgs,
  settings,
  ...
}: let
  shellBin =
    if settings.Shell == "nushell"
    then "nu"
    else settings.Shell;
in {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = settings.Shell == "fish";

    settings = {
      command = "${pkgs.${settings.Shell}}/bin/${shellBin} --login --interactive";
      font-family = "${settings.TerminalFont}";
      font-size = 12;
      theme = "TokyoNight Storm";
      window-padding-x = 10;
      window-padding-y = 10;
      cursor-color = "#7AA2F7";
      cursor-style = "block";
      cursor-style-blink = true;
      window-decoration = "none";
      window-theme = "dark";
      selection-background = "#364A82";
      selection-foreground = "#C0CAF5";

      keybind = [
        "super+t=new_tab"
        "super+w=close_surface"
      ];
    };
  };
}
