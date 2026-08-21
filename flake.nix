{
  description = "bloated rice";

  inputs = {
    nixpkgs.url = "https://git.monaie.ca/alteur/nixpkgs/archive/master.tar.gz";

    # master.url = "https://git.monaie.ca/alteur/nixpkgs/archive/master.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
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

    steam-gamescope-guide = {
      url = "github:shahnawazshahin/steam-using-gamescope-guide";
      flake = false;
    };

    tokyo-night = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    clear-sans = {
      url = "github:intel/clear-sans";
      flake = false;
    };

    dms-lyrics-on-panel = {
      url = "github:KangweiZhu/lyrics-on-panel";
      flake = false;
    };

    linux-arctis-manager = {
      url = "github:elegos/Linux-Arctis-Manager/v2.4.1";
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

    miyabi-cursor.url = "git+ssh://forgejo@git.monaie.ca/alteur/animated-cursors.git?ref=miyabi";

    ghostty.url = "github:ghostty-org/ghostty";

    grim-hyprland.url = "github:eriedaberrie/grim-hyprland";

    linux-desktop-gremlin.url = "github:iluvgirlswithglasses/linux-desktop-gremlin";

    nixcord.url = "github:FlameFlag/nixcord";

    dw-proton.url = "github:Momoyaan/dwproton-flake";

    hyprland.url = "github:hyprwm/Hyprland";

    nvim-dots.url = "git+https://git.monaie.ca/alteur/nixvim-dotfiles";

    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = inputs:
    import ./lib {
      inherit inputs;
    };
}
