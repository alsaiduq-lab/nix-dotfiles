{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    go
    go-tools
    gopls
  ];
}
