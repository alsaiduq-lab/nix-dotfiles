{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qt6.qtdeclarative
  ];
}
