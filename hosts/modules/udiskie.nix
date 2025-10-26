# TODO: figure out why this isnt working on wayland
{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
