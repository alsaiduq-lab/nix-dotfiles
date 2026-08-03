{
  lib,
  config,
  dotfiles,
  rsync,
  ...
}: {
  home.activation.dotfiles = let
    seedDotfiles =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList
        (_: entry:
          lib.optionalString (entry.enable or true) (
            if (entry.files or {}) == {}
            then ''
              if [ ! -e "${config.xdg.configHome}/${entry.to}" ]; then
                mkdir -p "$(dirname "${config.xdg.configHome}/${entry.to}")"
                ${rsync}/bin/rsync -rlD "${entry.from}" "${config.xdg.configHome}/${entry.to}"
              fi
            ''
            else
              lib.concatStringsSep "\n"
              (lib.mapAttrsToList
                (src: dest: ''
                  if [ ! -e "${config.xdg.configHome}/${entry.to}/${dest}" ]; then
                    mkdir -p "$(dirname "${config.xdg.configHome}/${entry.to}/${dest}")"
                    ${rsync}/bin/rsync -rlD "${entry.from}/${src}" "${config.xdg.configHome}/${entry.to}/${dest}"
                  fi
                '')
                entry.files)
          ))
        dotfiles);

    secrets = {
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
      # TODO: update this key before enabling
      # "api/cachix" = "CACHIX_AUTH_TOKEN";
      "github_token" = "GITHUB_TOKEN";
      "api/hf" = "HF_TOKEN";
    };

    createSecrets =
      lib.mapAttrsToList
      (secret: varName: "set -gx ${varName} (cat /run/secrets/${secret})")
      secrets;
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      ${seedDotfiles}
      cat > "${config.xdg.configHome}/fish/conf.d/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" createSecrets}
      EOF
    '';
}
