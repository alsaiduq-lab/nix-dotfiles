{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jq
    wrk
    gcc15
    pkg-config
    argc
    openssl
    cabextract
    xdg-utils
    cacert
    xdg-terminal-exec
  ];
}
