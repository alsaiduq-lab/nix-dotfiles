{settings, ...}: {
  programs.dms-greeter = {
    enable = true;
    compositor = {
      name = "hyprland";
      customConfig = ''
        hl.env("DMS_RUN_GREETER", "1")
      '';
    };
    configHome = "/home/${settings.user}";
    logs = {
      save = true;
      path = "/tmp/greeter.log";
    };
  };
}
