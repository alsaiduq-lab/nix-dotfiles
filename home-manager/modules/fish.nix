{
  pkgs,
  lib,
  ...
}: let
  envVars = {
    "api/openai" = "OPENAI_API_KEY";
    "api/deepseek" = "DEEPSEEK_API_KEY";
    "api/anthropic" = "ANTHROPIC_API_KEY";
    "api/openrouter" = "OPENROUTER_API_KEY";
    "api/xai" = "XAI_API_KEY";
    "api/perplexity" = "PERPLEXITY_API_KEY";
    "api/replicate" = "REPLICATE_API_TOKEN";
    "api/brave" = "BRAVE_API_KEY";
    "api/firecrawl" = "FIRECRAWL_API_KEY";
    "api/deepl" = "DEEPL_API_KEY";
    "api/gelbooru_id" = "GELBOORU_USER_ID";
    "api/gelbooru_api" = "GELBOORU_API_KEY";
    "api/fireworks" = "FIREWORKS_API_KEY";
    "api/cachix" = "CACHIX_AUTH_TOKEN";
    "api/vast" = "VAST_API_KEY";
  };

  envLines =
    lib.mapAttrsToList
    (secret: varName: "set -gx ${varName} (cat /run/secrets/${secret})")
    envVars;

  tokyonight-storm = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/545d72cde6400835d895160ecb5853874fd5156d/extras/fish/tokyonight_storm.fish";
    hash = "sha256-gDzHyaOFk96qiWZZmP6xnK74zrKdCnBRh2AzNNF5Vyg=";
  };
in {
  home.packages = with pkgs; [
    fish
    fzf
    ripgrep
    bat
    eza
    ugrep
    yazi
    chafa
    (btop.override {cudaSupport = true;})
    fastfetch
  ];

  xdg.configFile."fish/conf.d/envs.fish".text =
    "# Auto-generated from sops secrets\n"
    + lib.concatStringsSep "\n" envLines
    + "\n";

  xdg.configFile."fish/conf.d/tokyonight_storm.fish".source = tokyonight-storm;
}
