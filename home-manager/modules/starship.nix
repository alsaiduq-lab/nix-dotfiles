{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableInteractive = true;

    settings = {
      username = {
        format = " [╭─$user]($style)@";
        show_always = true;
        style_root = "bold cyan";
        style_user = "bold cyan";
      };

      hostname = {
        disabled = false;
        format = "[$hostname]($style) in ";
        ssh_only = false;
        style = "bold dimmed blue";
        trim_at = "-";
      };

      directory = {
        style = "purple";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "repo: ";
      };

      sudo = {
        disabled = false;
      };

      jobs = {
        format = "[⟪$symbol⟫]($style)";
        style = "bold cyan";
        symbol = "👷";
        threshold = 1;
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        deleted = "x";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        style = "white";
      };

      cmd_duration = {
        disabled = false;
        format = "took [$duration]($style)";
        min_time = 1;
      };

      nix_shell = {
        disabled = false;
        format = "[$symbol$state $name]($style) ";
        symbol = "";
        impure_msg = "nix";
        pure_msg = "nix";
        unknown_msg = "unknown";
        style = "bold blue";
      };

      battery = {
        disabled = true;

        display = [
          {
            disabled = false;
            style = "bold red";
            threshold = 15;
          }
          {
            disabled = true;
            style = "bold yellow";
            threshold = 50;
          }
          {
            disabled = true;
            style = "bold green";
            threshold = 80;
          }
        ];
      };

      character = {
        error_symbol = " [╰─✘](bold red)";
        success_symbol = " [╰─⟫](bold cyan)";
      };

      aws = {
        symbol = "󰸏 ";
      };

      conda = {
        symbol = " ";
      };

      dart = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
      };

      elixir = {
        symbol = " ";
      };

      elm = {
        symbol = " ";
      };

      git_branch = {
        symbol = " ";
      };

      golang = {
        symbol = " ";
      };

      hg_branch = {
        symbol = " ";
      };

      java = {
        symbol = " ";
      };

      julia = {
        symbol = " ";
      };

      nim = {
        symbol = " ";
      };

      nodejs = {
        symbol = " ";
      };

      package = {
        symbol = "󰔾 ";
      };

      perl = {
        symbol = " ";
      };

      php = {
        symbol = " ";
      };

      python = {
        symbol = " ";
      };

      ruby = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
      };

      swift = {
        symbol = "ﯣ ";
      };
    };
  };
}
