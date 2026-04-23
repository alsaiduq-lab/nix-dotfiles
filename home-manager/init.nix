{
  lib,
  config,
  pkgs,
  hyprlanddots,
  nvimDots,
  ...
}: {
  home.activation.init-seed = let
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
    tokyonightStorm = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/545d72cde6400835d895160ecb5853874fd5156d/extras/fish/tokyonight_storm.fish";
      hash = "sha256-gDzHyaOFk96qiWZZmP6xnK74zrKdCnBRh2AzNNF5Vyg=";
    };
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
          fish_dir="${config.xdg.configHome}/fish"
          fish_conf_dir="$fish_dir/conf.d"

          ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/fish/" "$fish_dir/"
          mkdir -p "$fish_conf_dir"

          if [ ! -e "$fish_conf_dir/envs.fish" ]; then
            cat > "$fish_conf_dir/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" envLines}
      EOF
          fi

          if [ ! -e "$fish_conf_dir/tokyonight_storm.fish" ]; then
            ${pkgs.coreutils}/bin/install -Dm644 "${tokyonightStorm}" "$fish_conf_dir/tokyonight_storm.fish"
          fi

          if [ ! -e "${config.xdg.configHome}/hypr" ]; then
            ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/hypr/" "${config.xdg.configHome}/hypr/"
          fi
          ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/cava/"    "${config.xdg.configHome}/cava/"
          if [ ! -e "${config.xdg.configHome}/nvim" ]; then
            ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${nvimDots}/" "${config.xdg.configHome}/nvim/"
          fi
          ${pkgs.rsync}/bin/rsync -rlD "${pkgs.dms-shell}/share/quickshell/dms/" "${config.xdg.configHome}/quickshell/"
          ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/starship.toml" "${config.xdg.configHome}/starship.toml"
    '';
}
