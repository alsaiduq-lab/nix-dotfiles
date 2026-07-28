{settings, ...}: {
  systemd.services.bot-auto = {
    description = "discord bot";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "/home/${settings.user}/ineffa/target/debug/ineffa";
      WorkingDirectory = "/home/${settings.user}/ineffa";
      Restart = "on-failure";
      RestartSec = 5;
      User = settings.user;
    };
  };
}
