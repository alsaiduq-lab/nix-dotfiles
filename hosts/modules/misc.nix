{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jq
    gcc15
    pkg-config
    argc
    openssl
    cabextract
    xdg-utils
    cacert
    xdg-terminal-exec
    patchelf
    bubblewrap
    hwinfo
  ];
}
