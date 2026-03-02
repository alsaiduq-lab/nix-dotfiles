{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sshfs
  ];
  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
