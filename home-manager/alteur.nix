{...}: {
  imports = [
    ./modules/fish.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/zellij.nix
  ];
  home = {
    username = "alteur";
    homeDirectory = "/home/alteur";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
  #home.packages = with pkgs; [
  #];
}
