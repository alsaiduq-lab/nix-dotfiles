{pkgs, ...}: {
  programs.brave = {
    enable = true;
    package = pkgs.brave;
  };
}
