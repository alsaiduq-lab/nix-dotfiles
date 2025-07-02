{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
    git
    git-lfs
    gh
    diff-so-fancy
  ];

  programs.git = {
    enable = true;
    includes = [
      {path = "${config.home.homeDirectory}/nix/.secrets/.git-config";}
    ];
    extraConfig = {
      credential.helper = "store --file=${config.home.homeDirectory}/nix/.secrets/.git-credentials";
    };
  };
}
