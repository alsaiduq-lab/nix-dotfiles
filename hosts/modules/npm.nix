{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs_24
    yarn
    bun
    typescript
  ];
}
