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
      "github_token" = "GITHUB_TOKEN";
    };
    envLines =
      lib.mapAttrsToList
      (secret: varName: "set -gx ${varName} (cat /run/secrets/${secret})")
      envVars;
    tokyonightStorm = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/545d72cde6400835d895160ecb5853874fd5156d/extras/fish/tokyonight_storm.fish";
      hash = "sha256-gDzHyaOFk96qiWZZmP6xnK74zrKdCnBRh2AzNNF5Vyg=";
    };
    dots = src: dest: ''
      if [ ! -e "${dest}" ]; then
        ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${src}" "${dest}"
      fi
    '';

    dotfiles =
      (lib.concatMapStringsSep "\n"
        (name: dots "${hyprlanddots}/${name}/" "${config.xdg.configHome}/${name}/")
        ["fish" "hypr" "cava"])
      + dots "${nvimDots}/" "${config.xdg.configHome}/nvim/"
      + dots "${hyprlanddots}/starship.toml" "${config.xdg.configHome}/starship.toml";
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      fish_dir="${config.xdg.configHome}/fish"
      quickshell_dir="${config.xdg.configHome}/quickshell"
      dms_dir="${pkgs.dms-shell}/share/quickshell/dms"

      ${dotfiles}

      if [ -L "$quickshell_dir" ]; then
        ${pkgs.coreutils}/bin/ln -sfnT "$dms_dir" "$quickshell_dir"
      elif [ ! -e "$quickshell_dir" ]; then
        ${pkgs.coreutils}/bin/ln -s "$dms_dir" "$quickshell_dir"
      elif [ -d "$quickshell_dir" ] && [ -f "$quickshell_dir/DMSShell.qml" ] && [ -f "$quickshell_dir/VERSION" ]; then
        quickshell_back="$quickshell_dir.$(${pkgs.coreutils}/bin/date +%Y%m%d%H%M%S)"
        ${pkgs.coreutils}/bin/mv "$quickshell_dir" "$quickshell_back"
        ${pkgs.coreutils}/bin/ln -s "$dms_dir" "$quickshell_dir"
        echo "Moved existing DMS quickshell tree to $quickshell_back"
      fi

      cat > "$fish_dir/conf.d/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" envLines}
      EOF

      if [ ! -e "$fish_dir/conf.d/tokyonight_storm.fish" ]; then
        ${pkgs.coreutils}/bin/install -Dm644 "${tokyonightStorm}" "$fish_dir/conf.d/tokyonight_storm.fish"
      fi
    '';
}
