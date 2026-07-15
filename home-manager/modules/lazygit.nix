{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    git
    git-lfs
    gh
    diff-so-fancy
  ];
  home.sessionVariables.LG_CONFIG_FILE = "${inputs.tokyo-night}/extras/lazygit/tokyonight_storm.yml,${config.xdg.configHome}/lazygit/config.yml";

  programs.lazygit = {
    enable = true;

    settings = {
      os = {
        edit = "${pkgs.zed-editor}/bin/zeditor {{filename}}";
        editAtLine = "${pkgs.zed-editor}/bin/zeditor {{filename}}:{{line}}";
        editAtLineAndWait = "${pkgs.zed-editor}/bin/zeditor --wait {{filename}}:{{line}}";
        openDirInEditor = "${pkgs.zed-editor}/bin/zeditor {{dir}}";
      };
    };
  };

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
      core.editor = "${pkgs.zed-editor}/bin/zeditor --wait";
      core.pager = "diff-so-fancy | less --tabs=4 -RF";
      interactive.diffFilter = "diff-so-fancy --patch";
    };
  };
}
