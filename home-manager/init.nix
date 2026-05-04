{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dotfiles.nix
  ];

  home.activation.init-seed = let
    dotfiles =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList
        (_: entry:
          lib.optionalString entry.enable ''
            if [ ! -e "${config.xdg.configHome}/${entry.to}" ]; then
              ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${entry.from}" "${config.xdg.configHome}/${entry.to}"
            fi
          '')
        config.dotfiles.files);
    quickshell =
      if config.dotfiles.quickshell == null || ! config.dotfiles.quickshell.enable
      then ""
      else ''
        if [ -L "${config.xdg.configHome}/quickshell" ]; then
          ${pkgs.coreutils}/bin/ln -sfnT "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
        elif [ ! -e "${config.xdg.configHome}/quickshell" ]; then
          ${pkgs.coreutils}/bin/ln -s "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
        elif [ -d "${config.xdg.configHome}/quickshell" ] && [ -f "${config.xdg.configHome}/quickshell/${config.dotfiles.quickshell.marker}" ]; then
          quickshell_back="${config.xdg.configHome}/quickshell.${config.dotfiles.quickshell.name}.$(${pkgs.coreutils}/bin/date +%Y%m%d%H%M%S)"
          ${pkgs.coreutils}/bin/mv "${config.xdg.configHome}/quickshell" "$quickshell_back"
          ${pkgs.coreutils}/bin/ln -s "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
        fi
      '';

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
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      ${dotfiles}
      ${quickshell}
      cat > "${config.xdg.configHome}/fish/conf.d/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" envLines}
      EOF
      if [ ! -e "${config.xdg.configHome}/fish/conf.d/tokyonight_storm.fish" ]; then
        ${pkgs.coreutils}/bin/install -Dm644 "${tokyonightStorm}" "${config.xdg.configHome}/fish/conf.d/tokyonight_storm.fish"
      fi
    '';
}
