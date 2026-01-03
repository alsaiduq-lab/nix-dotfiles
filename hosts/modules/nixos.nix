{
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
  nix.settings = {
    auto-optimise-store = true;
    max-jobs =
      if config.networking.hostName == "magus"
      then 1
      else "auto";
    cores =
      if config.networking.hostName == "magus"
      then 1
      else 0;
    experimental-features = ["nix-command" "flakes"];
    substituters =
      [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ]
      ++ lib.optionals (config.networking.hostName != "magus") [
        "https://nix-gaming.cachix.org"
        "https://ghostty.cachix.org"
        "https://hyprland.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://ezkea.cachix.org"
      ];
    trusted-public-keys =
      [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ]
      ++ lib.optionals (config.networking.hostName != "magus") [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
  };
}
