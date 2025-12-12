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
    settings = {
      user.name = "alsaiduq-lab";
      user.email = "riiidge.racer@gmail.com";
      credential.helper = "store --file=${config.home.homeDirectory}/nix/.secrets/.git-credentials";
    };
  };
}
