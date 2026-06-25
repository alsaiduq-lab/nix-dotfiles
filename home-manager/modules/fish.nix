{
  pkgs,
  nvm-fish,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    ripgrep
    eza
    ugrep
    yazi
    chafa
    fastfetch
    nix-your-shell
  ];

  programs.direnv = {
    enable = true ;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      prettybat
    ];
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass;
      }
      {
        name = "nvm";
        src = nvm-fish;
      }
    ];

    shellAliases = {
      ls = "eza -al --color=always --group-directories-first --icons";
      zed = "zeditor";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      grep = "ugrep --color=auto";
      ip = "ip -color";
      wget = "wget -c";
      journal = "journalctl -p 3 -xb";
    };

    functions = {
      __history_previous_command = ''
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      '';

      # needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
      __history_previous_command_arguments = ''
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      '';

      history = "builtin history --show-time='%F %T '";

      backup = {
        argumentNames = ["filename"];
        body = "cp $filename $filename.bak";
      };

      pip-freeze = ''
        python -c "
        from importlib.metadata import distributions
        for d in sorted(distributions(), key=lambda x: x.metadata['Name'].lower()):
            print(f\"{d.metadata['Name']}=={d.version}\")
        "
      '';

      cat = {
        wraps = "bat";
        body = ''
          if not isatty stdout; or not type -q bat
            command cat $argv
            return
          end
          if contains -- -f $argv
            bat --paging=never --style=numbers,changes (string match -v -- -f $argv)
            return
          end
          for file in $argv
            if test -f "$file"; and test (wc -l < "$file") -gt 500
              echo "$file: "(wc -l < "$file")" lines (-f to show)"
              return
            end
          end
          bat --paging=never --style=numbers,changes $argv
        '';
      };
    };

    interactiveShellInit = ''
      set fish_greeting
      set -gx VIRTUAL_ENV_DISABLE_PROMPT "1"

      if test -f ~/.fish_profile
        source ~/.fish_profile
      end

      if test -d ~/.local/bin
        fish_add_path -g ~/.local/bin
      end
      if test -d ~/.cargo/bin
        fish_add_path -g ~/.cargo/bin
      end
      if test -d ~/.npm-global/bin
        fish_add_path -g ~/.npm-global/bin
      end

      if type -q qtile
        set -gx QT_QPA_PLATFORMTHEME qt5ct
      end

      # settings for https://github.com/franciscolourenco/done
      set -U __done_min_cmd_duration 10000
      set -U __done_notification_urgency_level low

      if [ "$fish_key_bindings" = fish_vi_key_bindings ]
        bind -Minsert ! __history_previous_command
        bind -Minsert '$' __history_previous_command_arguments
      else
        bind ! __history_previous_command
        bind '$' __history_previous_command_arguments
      end

      set -gx SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
      set -gx REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

      if type -q nix-your-shell
        nix-your-shell fish | source
      end

      if status --is-interactive
        if not set -q IN_NIX_SHELL
          if type -q check_and_display
            check_and_display
          else
            fastfetch -c neofetch
          end
        end
      end
    '';
  };
}
