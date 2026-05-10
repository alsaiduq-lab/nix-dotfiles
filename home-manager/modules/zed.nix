{
  config,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "material-icon-theme"
      "tokyo-night"
      "discord-presence"
      "nix"
      "toml"
      "html"
      "scss"
      "lua"
    ];

    extraPackages = with pkgs; [
      rustc
      cargo
      nixd
      alejandra
      statix
      deadnix
      basedpyright
      ruff
      taplo
      yaml-language-server
      vscode-langservers-extracted
      prettier
      lua-language-server
      marksman
    ];

    userSettings = {
      icon_theme = {
        mode = "system";
        light = "Material Icon Theme";
        dark = "Material Icon Theme";
      };

      base_keymap = "JetBrains";
      vim_mode = true;

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      agent_servers = {
        codex-acp = {
          type = "registry";
        };
      };

      agent = {
        tool_permissions = {
          default = "confirm";

          tools = {
            terminal = {
              default = "confirm";
              always_allow = [
                {pattern = "^rg\\b";}
                {pattern = "^fd\\b";}
                {pattern = "^ls\\b";}
                {pattern = "^cat\\s";}
              ];
              always_confirm = [
                {pattern = "^sudo\\b";}
                {pattern = "^git\\s+push\\b";}
              ];
            };
            edit_file.default = "confirm";
            delete_path.default = "confirm";
            move_path.default = "confirm";
          };
        };
      };

      ui_font_size = 16;
      buffer_font_size = 15;
      buffer_font_family = config.theme.TerminalFont;

      theme = {
        mode = "system";
        light = "Ayu Light";
        dark = "Tokyo Night Storm";
      };

      terminal = {
        shell = {
          program = config.theme.Shell;
        };
      };

      remove_trailing_whitespace_on_save = true;
      ensure_final_newline_on_save = true;
      format_on_save = "on";
      semantic_tokens = "combined";

      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };

      languages = {
        Nix = {
          language_servers = ["nixd" "!nil" "discord_presence"];
          formatter = {
            external = {
              command = "${pkgs.alejandra}/bin/alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };

        Python = {
          language_servers = ["basedpyright" "ruff" "discord_presence"];
          formatter = {
            external = {
              command = "${pkgs.ruff}/bin/ruff";
              arguments = ["format" "--stdin-filename" "{buffer_path}" "-"];
            };
          };
        };

        HTML = {
          formatter = {
            external = {
              command = "${pkgs.prettier}/bin/prettier";
              arguments = ["--stdin-filepath" "{buffer_path}"];
            };
          };
        };

        SCSS = {
          formatter = {
            external = {
              command = "${pkgs.prettier}/bin/prettier";
              arguments = ["--stdin-filepath" "{buffer_path}"];
            };
          };
        };
      };

      lsp = {
        nixd = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
          };
        };

        basedpyright = {
          binary = {
            path = "${pkgs.basedpyright}/bin/basedpyright-langserver";
            arguments = ["--stdio"];
          };
        };

        ruff = {
          binary = {
            path = "${pkgs.ruff}/bin/ruff";
            arguments = ["server"];
          };
        };

        discord_presence = {
          initialization_options = {
            application_id = "1263505205522337886";
            base_icons_url = "https://raw.githubusercontent.com/vyfor/icons/master/icons/minecraft/dark";

            details = "Editing {filename}";
            state = "In {workspace}";

            large_image = "{base_icons_url}/{language:lo}.png";
            large_text = "{language:u}";

            small_image = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/zed.png";
            small_text = "Zed";

            git_integration = true;

            git_host_overrides = {
              "git.monaie.ca" = "git.monaie.ca";
              "github.com" = "github.com";
            };

            idle = {
              timeout = 300;
              action = "clear_activity";
            };
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-p" = "command_palette::Toggle";
          "ctrl-," = "zed::OpenSettings";
          "ctrl-alt-," = "zed::OpenSettingsFile";
          "ctrl-alt-k" = "zed::OpenKeymapFile";
          "alt-1" = "project_panel::ToggleFocus";
          "alt-7" = "outline_panel::ToggleFocus";
          "alt-6" = "diagnostics::Deploy";
          "alt-f12" = "terminal_panel::ToggleFocus";
          "ctrl-alt-t" = "workspace::NewTerminal";
          "ctrl-alt-a" = "agent::NewThread";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "ctrl-alt-l" = "editor::Format";
          "alt-enter" = "editor::ToggleCodeActions";
          "shift-f6" = "editor::Rename";
          "ctrl-b" = "editor::GoToDefinition";
          "ctrl-alt-b" = "editor::GoToImplementation";
          "ctrl-shift-b" = "editor::GoToTypeDefinition";
          "ctrl+f2" = "editor::GoToDiagnostic";
          "shift-f2" = "editor::GoToPreviousDiagnostic";
          "ctrl-alt-h" = "editor::ToggleInlayHints";
          "ctrl-alt-g" = "editor::ToggleGitBlameInline";
          "ctrl-/" = "editor::ToggleComments";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-shift-c" = "terminal::Copy";
          "ctrl-shift-v" = "terminal::Paste";
        };
      }
    ];
  };
}
