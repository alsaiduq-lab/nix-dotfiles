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
          "ctrl-alt-k" = "zed::OpenKeymapFile";
          "alt-1" = "project_panel::ToggleFocus";
          "alt-7" = "outline_panel::ToggleFocus";
          "alt-6" = "diagnostics::Deploy";
          "alt-f12" = "terminal_panel::ToggleFocus";
          "ctrl-alt-t" = "workspace::NewTerminal";
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
          "f2" = "editor::GoToDiagnostic";
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
