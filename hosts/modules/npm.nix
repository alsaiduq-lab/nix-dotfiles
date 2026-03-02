{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs_24
    nodePackages.npm
    yarn
    bun
    nodePackages.typescript
  ];
}
