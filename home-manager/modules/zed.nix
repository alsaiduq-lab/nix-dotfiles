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
      "nix"
      "hyprlang"
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
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-p" = "command_palette::Toggle";
          "ctrl-," = "zed::OpenSettings";
          "ctrl-alt-," = "zed::OpenSettingsFile";
          "ctrl-k ctrl-s" = "zed::OpenKeymap";
          "ctrl-k ctrl-shift-s" = "zed::OpenKeymapFile";
          "ctrl-shift-e" = "project_panel::ToggleFocus";
          "ctrl-j" = "workspace::ToggleBottomDock";
          "ctrl-alt-b" = "workspace::ToggleRightDock";
          "ctrl-shift-o" = "outline_panel::Toggle";
          "ctrl-shift-f" = "pane::DeploySearch";
          "ctrl-~" = "workspace::NewTerminal";
          "ctrl-`" = "terminal_panel::ToggleFocus";
          "ctrl-shift-m" = "diagnostics::Deploy";
          "ctrl-alt-shift-m" = "diagnostics::DeployCurrentFile";
          "ctrl-alt-l" = "lsp_tool::ToggleMenu";
          "ctrl-k ctrl-l" = "dev::OpenLanguageServerLogs";
          "ctrl-k ctrl-alt-l" = "zed::OpenLog";
          "ctrl-k ctrl-alt-k" = "dev::OpenKeyContextView";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "ctrl-shift-i" = "editor::Format";
          "ctrl-k ctrl-shift-i" = "editor::FormatSelections";
          "ctrl-." = "editor::ToggleCodeActions";
          "f2" = "editor::Rename";
          "f12" = "editor::GoToDefinition";
          "ctrl-f12" = "editor::GoToTypeDefinition";
          "shift-f12" = "editor::GoToImplementation";
          "f8" = "editor::GoToDiagnostic";
          "shift-f8" = "editor::GoToPreviousDiagnostic";
          "ctrl-k ctrl-alt-r" = "editor::RestartLanguageServer";
          "ctrl-k ctrl-alt-s" = "editor::StopLanguageServer";
          "ctrl-k ctrl-alt-c" = "editor::CancelLanguageServerWork";
          "ctrl-k ctrl-alt-h" = "editor::ToggleInlayHints";
          "ctrl-k ctrl-alt-g" = "editor::ToggleGitBlameInline";
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
