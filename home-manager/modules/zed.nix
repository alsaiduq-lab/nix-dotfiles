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
          program = "fish";
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
          language_servers = ["nixd"];
          formatter = {
            external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };

        Python = {
          language_servers = ["basedpyright" "ruff"];
          formatter = {
            external = {
              command = "ruff";
              arguments = ["format" "--stdin-filename" "{buffer_path}" "-"];
            };
          };
        };
      };

      lsp = {
        nixd = {
          binary.path = "nixd";
        };

        basedpyright = {
          binary = {
            path = "basedpyright-langserver";
            arguments = ["--stdio"];
          };
        };

        ruff = {
          binary = {
            path = "ruff";
            arguments = ["server"];
          };
        };

        discord_presence = {
          initialization_options = {
            application_id = "1263505205522337886";
            details = "In {workspace} - {git_branch}";
            base_icons_url = "https://raw.githubusercontent.com/vyfor/icons/master/icons/minecraft/dark";
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
          ctrl-shift-p = "command_palette::Toggle";
          ctrl-shift-comma = "zed::OpenSettings";
          ctrl-shift-k = "zed::OpenKeymap";
          ctrl-alt-shift-k = "dev::OpenKeyContextView";
          ctrl-alt-shift-l = "zed::OpenLog";
          ctrl-shift-e = "project_panel::ToggleFocus";
          ctrl-shift-b = "workspace::ToggleBottomDock";
          ctrl-shift-r = "workspace::ToggleRightDock";
          ctrl-shift-o = "outline_panel::Toggle";
          ctrl-shift-f = "pane::DeploySearch";
          ctrl-shift-t = "workspace::NewTerminal";
          ctrl-grave = "terminal_panel::ToggleFocus";
          ctrl-shift-d = "diagnostics::Deploy";
          ctrl-alt-d = "diagnostics::DeployCurrentFile";
          ctrl-alt-m = "lsp_tool::ToggleMenu";
          ctrl-alt-shift-s = "dev::OpenLanguageServerLogs";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          ctrl-alt-l = "editor::Format";
          ctrl-alt-shift-l = "editor::FormatSelections";
          alt-enter = "editor::ToggleCodeActions";
          shift-f6 = "editor::Rename";
          ctrl-b = "editor::GoToDefinition";
          ctrl-alt-b = "editor::GoToTypeDefinition";
          ctrl-alt-i = "editor::GoToImplementation";
          f2 = "editor::GoToDiagnostic";
          shift-f2 = "editor::GoToPreviousDiagnostic";
          ctrl-alt-r = "editor::RestartLanguageServer";
          ctrl-alt-s = "editor::StopLanguageServer";
          ctrl-alt-c = "editor::CancelLanguageServerWork";
          ctrl-alt-h = "editor::ToggleInlayHints";
          ctrl-alt-g = "editor::ToggleGitBlameInline";
          ctrl-slash = "editor::ToggleComments";
        };
      }
      {
        context = "Terminal";
        bindings = {
          ctrl-shift-c = "terminal::Copy";
          ctrl-shift-v = "terminal::Paste";
        };
      }
    ];
  };
}
