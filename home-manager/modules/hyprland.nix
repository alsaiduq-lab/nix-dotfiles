{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    swayidle
    swaylock-effects
    wlogout
    wl-clipboard
    wofi
    hyprshot
    quickshell
  ];
}
