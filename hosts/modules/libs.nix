{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    poppler-utils
    libnotify
  ];
}
