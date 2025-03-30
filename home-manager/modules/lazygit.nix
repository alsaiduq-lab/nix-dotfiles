{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
  ];

  programs.git = {
    enable = true;
    includes = [
      { path = "./.secrets/.git-config"; }
    ];
    extraConfig = {
      credential.helper = "store --file ./.secrets/.git-credentials";
    };
  };
}
