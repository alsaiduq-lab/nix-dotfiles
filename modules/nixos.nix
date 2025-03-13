{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Fix Python package issues
  nixpkgs.overlays = [
    (final: prev: {
      python310Packages = prev.python310Packages.override {
        overrides = pyFinal: pyPrev: {
          terminado = pyPrev.terminado.overrideAttrs (old: {
            doCheck = false;
            doInstallCheck = false;
          });
        };
      };
    })
  ];

  # Enable nix-index for command-not-found
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
  # Setup nix settings
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
