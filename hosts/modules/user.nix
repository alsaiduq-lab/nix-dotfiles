{pkgs, ...}: {
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.cobray = {
    isNormalUser = true;
    description = "Mon Aie";
    extraGroups = ["networkmanager" "wheel" "docker" "video"];
    shell = pkgs.fish;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  programs.fish = {
    enable = true;
  };
}
