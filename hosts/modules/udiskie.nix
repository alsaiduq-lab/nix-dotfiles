{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
