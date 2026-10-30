{pkgs, ...}: {
  home.packages = with pkgs; [
    vivify
  ];
}
