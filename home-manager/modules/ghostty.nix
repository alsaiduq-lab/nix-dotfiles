{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    ghostty
    fastfetch
  ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      command = "${pkgs.fish}/bin/fish --login --interactive";
      font-family = "0xProto Nerd Font";
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
  home.file."${config.xdg.configHome}/ghostty/config".force = lib.mkForce true;
}
