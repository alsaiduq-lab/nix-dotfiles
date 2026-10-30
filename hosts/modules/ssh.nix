{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sshfs
  ];
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
