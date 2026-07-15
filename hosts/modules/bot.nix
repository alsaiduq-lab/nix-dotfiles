{...}: {
  systemd.services.bot-auto = {
    description = "discord bot";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "/home/alteur/ineffa/target/debug/ineffa";
      WorkingDirectory = "/home/alteur/ineffa";
      Restart = "on-failure";
      RestartSec = 5;
      User = "alteur";
    };
  };
}
