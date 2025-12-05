{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libclang
    texlive.combined.scheme-full
    poppler-utils
    libnotify
    egl-wayland
    vulkan-tools
    libva-utils
    vdpauinfo
    libadwaita
    gtk4
    pango
    cairo
    xz
    bzip2
    libc
  ];
}
