{
  settings,
  pkgs,
  ...
}: {
  imports = [
    ./modules
  ];

  home.username = "${settings.user}";
  home.homeDirectory = "/home/${settings.user}";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  #home.packages = with pkgs; [
  #];
}
