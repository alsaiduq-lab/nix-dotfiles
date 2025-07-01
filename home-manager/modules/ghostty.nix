{pkgs, ...}: {
  home.packages = with pkgs; [
    fastfetch
  ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
  };
}
