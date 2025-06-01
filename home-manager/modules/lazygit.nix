{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    git
    git-lfs
    gitAndTools.gh
    gitAndTools.diff-so-fancy
  ];

  programs.git = {
    enable = true;
    includes = [
      {path = "./.secrets/.git-config";}
    ];
    extraConfig = {
      credential.helper = "store --file ./.secrets/.git-credentials";
    };
  };
}
