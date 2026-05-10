{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dotfiles.nix
  ];

  home.activation.seed-dotfiles = let
    dotfiles =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList
        (_: entry:
          lib.optionalString entry.enable (
            if entry.files == {}
            then ''
              if [ ! -e "${config.xdg.configHome}/${entry.to}" ]; then
                mkdir -p "$(dirname "${config.xdg.configHome}/${entry.to}")"
                ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${entry.from}" "${config.xdg.configHome}/${entry.to}"
              fi
            ''
            else
              lib.concatStringsSep "\n"
              (lib.mapAttrsToList
                (src: dest: ''
                  if [ ! -e "${config.xdg.configHome}/${entry.to}/${dest}" ]; then
                    mkdir -p "$(dirname "${config.xdg.configHome}/${entry.to}/${dest}")"
                    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${entry.from}/${src}" "${config.xdg.configHome}/${entry.to}/${dest}"
                  fi
                '')
                entry.files)
          ))
        (removeAttrs config.dotfiles ["quickshell"]));

    quickshell =
      if config.dotfiles.quickshell == null || ! config.dotfiles.quickshell.enable
      then ""
      else ''
        if [ -L "${config.xdg.configHome}/quickshell" ]; then
          ln -sfnT "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
        elif [ ! -e "${config.xdg.configHome}/quickshell" ]; then
          ln -s "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
        elif [ -d "${config.xdg.configHome}/quickshell" ] && [ -f "${config.xdg.configHome}/quickshell/${config.dotfiles.quickshell.marker}" ]; then
          quickshell_back="${config.xdg.configHome}/quickshell.${config.dotfiles.quickshell.name}.$(cat "${config.dotfiles.quickshell.from}/VERSION")"
          mv "${config.xdg.configHome}/quickshell" "$quickshell_back"
          ln -s "${config.dotfiles.quickshell.from}" "${config.xdg.configHome}/quickshell"
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
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      ${dotfiles}
      ${quickshell}
      cat > "${config.xdg.configHome}/fish/conf.d/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" envLines}
      EOF
    '';
}
