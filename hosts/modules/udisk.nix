{pkgs, ...}: {
  environment.systemPackages = with pkgs; [udiskie];
  services.udisks2.enable = true;
}
