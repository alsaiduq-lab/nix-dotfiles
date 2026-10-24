{
  description = "bloated rice";

  inputs = {
    nixpkgs.url = "https://git.monaie.ca/alteur/nixpkgs/archive/master.tar.gz";

    # master.url = "https://git.monaie.ca/alteur/nixpkgs/archive/master.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
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

    discord-ips = {
      url = "file+https://cdn.discordapp.com/ipranges/discord.json";
      flake = false;
    };

    proton-ge = {
      url = "github:Daaboulex/proton-ge-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    mikuboot = {
      url = "gitlab:evysgarden/mikuboot";
      inputs.nixpkgs.follows = "";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    grim-hyprland.url = "github:eriedaberrie/grim-hyprland";

    hyprland-scroll-overview = {
      url = "github:silicalet/hyprland-scroll-overview/25163b1e6a61c67e6b0cc7b5c51ab584b18f70e8";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    torrserver = {
      url = "github:YouROK/TorrServer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    miyabi-cursor.url = "git+ssh://forgejo@git.monaie.ca/alteur/animated-cursors.git?ref=miyabi";

    ghostty.url = "github:ghostty-org/ghostty";

    linux-desktop-gremlin.url = "github:iluvgirlswithglasses/linux-desktop-gremlin";

    nixcord.url = "github:4evy/nixcord";

    dw-proton.url = "github:Momoyaan/dwproton-flake";

    nvim-dots.url = "git+https://git.monaie.ca/alteur/nixvim-dotfiles";

    llm-agents.url = "github:numtide/llm-agents.nix";

    assets.url = "git+ssh://forgejo@git.monaie.ca/alteur/assets.git";
  };

  outputs = inputs:
    import ./lib {
      inherit inputs;
    };
}
