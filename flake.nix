{
  description = "bloated rice";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:alsaiduq-lab/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugins-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-dots = {
      url = "github:alsaiduq-lab/nvim-dotfiles";
      flake = false;
    };

    tokyo-night = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    modernx = {
      url = "github:cyl0/ModernX?ref=0.6.1";
      flake = false;
    };

    anime4k = {
      url = "github:bloc97/Anime4K?ref=v4.0.1";
      flake = false;
    };

    nvm-fish = {
      url = "github:jorgebucaran/nvm.fish";
      flake = false;
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    miku-cursor.url = "git+https://git.monaie.ca/alteur/animated-cursors";

    ghostty.url = "github:ghostty-org/ghostty";

    grim-hyprland.url = "github:eriedaberrie/grim-hyprland";

    linux-desktop-gremlin.url = "github:iluvgirlswithglasses/linux-desktop-gremlin";

    nixcord.url = "github:FlameFlag/nixcord";

    dw-proton.url = "github:Momoyaan/dwproton-flake";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs:
    import ./flake {
      inherit inputs;
    };
}
