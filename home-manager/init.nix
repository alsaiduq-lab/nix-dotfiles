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
  in
    lib.hm.dag.entryAfter ["linkGeneration"] ''
          fish_dir="${config.xdg.configHome}/fish"
          fish_conf_dir="$fish_dir/conf.d"
          quickshell_dir="${config.xdg.configHome}/quickshell"
          quickshell_target="${pkgs.dms-shell}/share/quickshell/dms"

          if [ ! -e "$fish_dir" ]; then
            ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/fish/" "$fish_dir/"
          fi
          mkdir -p "$fish_conf_dir"
          if [ ! -e "${config.xdg.configHome}/hypr" ]; then
            ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/hypr/" "${config.xdg.configHome}/hypr/"
          fi
          ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/cava/"    "${config.xdg.configHome}/cava/"
          if [ ! -e "${config.xdg.configHome}/nvim" ]; then
            ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${nvimDots}/" "${config.xdg.configHome}/nvim/"
          fi
          if [ -L "$quickshell_dir" ]; then
            ${pkgs.coreutils}/bin/ln -sfnT "$quickshell_target" "$quickshell_dir"
          elif [ ! -e "$quickshell_dir" ]; then
            ${pkgs.coreutils}/bin/ln -s "$quickshell_target" "$quickshell_dir"
          elif [ -d "$quickshell_dir" ] && [ -f "$quickshell_dir/DMSShell.qml" ] && [ -f "$quickshell_dir/VERSION" ]; then
            quickshell_backup="$quickshell_dir.bak.$(${pkgs.coreutils}/bin/date +%Y%m%d%H%M%S)"
            ${pkgs.coreutils}/bin/mv "$quickshell_dir" "$quickshell_backup"
            ${pkgs.coreutils}/bin/ln -s "$quickshell_target" "$quickshell_dir"
            echo "Moved existing DMS quickshell tree to $quickshell_backup"
          else
            echo "Skipping DMS quickshell link because $quickshell_dir exists and is not the seeded DMS tree" >&2
          fi
          ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/starship.toml" "${config.xdg.configHome}/starship.toml"

          cat > "$fish_conf_dir/envs.fish" <<'EOF'
      # Auto-generated from sops secrets
      ${lib.concatStringsSep "\n" envLines}
      EOF

          if [ ! -e "$fish_conf_dir/tokyonight_storm.fish" ]; then
            ${pkgs.coreutils}/bin/install -Dm644 "${tokyonightStorm}" "$fish_conf_dir/tokyonight_storm.fish"
          fi

          cat > "$fish_conf_dir/update.fish" <<'EOF'
      function __nix_update_realpath
          set -l target $argv[1]

          if not test -d "$target"
              return 1
          end

          pushd "$target" >/dev/null
          or return 1

          pwd -P
          set -l status_code $status
          popd >/dev/null

          return $status_code
      end

      function __nix_update_find_flake
          for candidate in $argv
              if test -n "$candidate"; and test -f "$candidate/flake.nix"
                  __nix_update_realpath "$candidate"
                  return $status
              end
          end

          if test -f "$PWD/flake.nix"
              __nix_update_realpath "$PWD"
              return $status
          end

          set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
          if test -n "$git_root"; and test -f "$git_root/flake.nix"
              __nix_update_realpath "$git_root"
              return $status
          end

          if test -f "$HOME/nix/flake.nix"
              __nix_update_realpath "$HOME/nix"
              return $status
          end

          return 1
      end

      function __nix_update_host_exists
          set -l flake_dir $argv[1]
          set -l host $argv[2]

          test -n "$host"
          or return 1

          command nix eval --raw "$flake_dir#nixosConfigurations.$host.config.networking.hostName" >/dev/null 2>&1
      end

      function __nix_update_hosts
          set -l flake_dir $argv[1]

          command nix eval --raw "$flake_dir#nixosConfigurations" --apply 'configs: builtins.concatStringsSep "\n" (builtins.attrNames configs)' 2>/dev/null
      end

      function __nix_update_detect_host
          set -l flake_dir $argv[1]
          set -l override $argv[2]

          if test -n "$override"
              printf '%s\n' "$override"
              return 0
          end

          if set -q NIX_UPDATE_HOST; and test -n "$NIX_UPDATE_HOST"
              printf '%s\n' "$NIX_UPDATE_HOST"
              return 0
          end

          set -l local_host (command hostname -s 2>/dev/null)
          set -l hosts (__nix_update_hosts "$flake_dir")

          if contains -- "$local_host" $hosts
              printf '%s\n' "$local_host"
              return 0
          end

          if test (count $hosts) -eq 1
              printf '%s\n' "$hosts[1]"
              return 0
          end

          return 1
      end

      function __nix_update_boot_reasons
          set -l base_system $argv[1]
          set -l next_system $argv[2]

          for link in kernel kernel-modules initrd
              set -l current (command readlink -f "$base_system/$link" 2>/dev/null)
              set -l next (command readlink -f "$next_system/$link" 2>/dev/null)

              if test -n "$current"; and test -n "$next"; and test "$current" != "$next"
                  printf '%s\n' "$link"
              end
          end
      end

      function nix-update --description "Update flake inputs and package deps"
          set -l flake_arg
          set -l host_arg

          for arg in $argv
              if test -d "$arg"
                  set flake_arg "$arg"
              else
                  set host_arg "$arg"
              end
          end

          set -l flake_dir (__nix_update_find_flake "$flake_arg")
          if test -z "$flake_dir"
              echo "nix-update: could not find a flake directory" >&2
              return 1
          end

          set -l host (__nix_update_detect_host "$flake_dir" "$host_arg")
          if test -z "$host"
              echo "nix-update: could not infer host; pass a nixosConfigurations attr explicitly" >&2
              echo "available hosts:" >&2
              for available_host in (__nix_update_hosts "$flake_dir")
                  echo "  $available_host" >&2
              end
              return 1
          end

          if not __nix_update_host_exists "$flake_dir" "$host"
              echo "nix-update: no nixosConfigurations.$host in $flake_dir" >&2
              echo "available hosts:" >&2
              for available_host in (__nix_update_hosts "$flake_dir")
                  echo "  $available_host" >&2
              end
              return 1
          end

          if set -q GITHUB_TOKEN; and test -n "$GITHUB_TOKEN"
              if set -q NIX_CONFIG; and test -n "$NIX_CONFIG"
                  set -gx NIX_CONFIG "access-tokens = github.com=$GITHUB_TOKEN
      $NIX_CONFIG"
              else
                  set -gx NIX_CONFIG "access-tokens = github.com=$GITHUB_TOKEN"
              end
          end

          echo "flake: $flake_dir"
          echo "host: $host"

          pushd "$flake_dir" >/dev/null
          or return 1

          echo "updating flake inputs..."
          command nix flake update
          or begin
              set -l status_code $status
              popd >/dev/null
              return $status_code
          end

          echo "updating package hashes..."
          command nix run .#update-deps
          or begin
              set -l status_code $status
              popd >/dev/null
              return $status_code
          end

          echo "building system closure..."
          set -l build_output (command nix build ".#nixosConfigurations.$host.config.system.build.toplevel" --no-link --print-out-paths)
          or begin
              set -l status_code $status
              popd >/dev/null
              return $status_code
          end

          set -l next_system $build_output[-1]
          if test -z "$next_system"
              echo "nix-update: nix build did not return a system path" >&2
              popd >/dev/null
              return 1
          end

          echo
          echo "package changes for nh:"
          if test -e /run/current-system
              command nix store diff-closures /run/current-system "$next_system"
              or true
          else
              echo "  /run/current-system is missing; skipping closure diff"
          end

          set -l base_system /run/booted-system
          if not test -e "$base_system"
              set base_system /run/current-system
          end

          set -l boot_reasons
          if test -e "$base_system"
              set boot_reasons (__nix_update_boot_reasons "$base_system" "$next_system")
          end

          echo
          if test (count $boot_reasons) -gt 0
              echo "boot required: kernel-level paths changed"
              for reason in $boot_reasons
                  echo "  - $reason"
              end
              echo
              echo "run:"
              echo "  nh os boot --hostname $host --diff always $flake_dir"
              echo "  reboot"
          else
              echo "switch safe: kernel, initrd, and kernel modules match the booted generation"
              echo
              echo "run:"
              echo "  nh os switch --hostname $host --diff always $flake_dir"
          end

          echo
          echo "built system: $next_system"

          popd >/dev/null
      end
      EOF
    '';
}
