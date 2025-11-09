{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libclang
    texlive.combined.scheme-full
    poppler_utils
    libnotify
    egl-wayland
    vulkan-tools
    libva-utils
    vdpauinfo
  ];
}
