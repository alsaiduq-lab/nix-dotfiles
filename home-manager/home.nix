{settings, ...}: {
  programs.home-manager.enable = true;
  home = {
    username = settings.user;
    homeDirectory = "/home/${settings.user}";
    stateVersion = "26.05";
    enableNixpkgsReleaseCheck = false;
  };
}
