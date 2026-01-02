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
      {path = "${config.home.homeDirectory}/nix/.secrets/.gitconfig";}
    ];
    settings = {
      credential.helper = "store --file=${config.home.homeDirectory}/nix/.secrets/.git-credentials";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.pager = "diff-so-fancy | less --tabs=4 -RF";
      interactive.diffFilter = "diff-so-fancy --patch";
    };
  };
}
