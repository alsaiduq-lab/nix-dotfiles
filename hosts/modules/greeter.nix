{
  settings,
  lib,
  ...
}: {
  services.displayManager.autoLogin.enable = lib.mkForce false;

  programs.dms-greeter = {
    enable = true;
    compositor = {
      name = "hyprland";
      customConfig = ''
        hl.env("DMS_RUN_GREETER", "1")
        hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
        hl.env("XDG_SESSION_TYPE", "wayland")
        hl.env("XDG_SESSION_DESKTOP", "Hyprland")
        hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
        hl.env("GBM_BACKEND", "nvidia-drm")
        hl.env("LIBVA_DRIVER_NAME", "nvidia")
        hl.env("QT_QPA_PLATFORM", "wayland")
        hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

        hl.config({
          cursor = {
            no_hardware_cursors = 2,
            use_cpu_buffer = 2,
          },
        })

        hl.config({
          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            force_default_wallpaper = 0,
          },
        })
      '';
    };
    configHome = "/home/${settings.user}";
    logs = {
      save = true;
      path = "/tmp/greeter.log";
    };
  };
}
