{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    git
    git-lfs
    gh
    diff-so-fancy
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      credential."https://git.monaie.ca".helper = "!cat /run/secrets/forgejo-cred #";
      credential."https://github.com".helper = "!cat /run/secrets/git-credentials #";
      user.name = "alsaiduq-lab";
      user.email = "riiidge.racer@gmail.com";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.pager = "diff-so-fancy | less --tabs=4 -RF";
      interactive.diffFilter = "diff-so-fancy --patch";
    };
  };
}
