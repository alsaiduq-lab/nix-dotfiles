{pkgs, ...}: {
  nix.settings = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  environment.systemPackages = with pkgs; [
    claude-desktop
    claude-code
  ];

  xdg.mime.defaultApplications."x-scheme-handler/claude" = "claude-desktop.desktop";
}
