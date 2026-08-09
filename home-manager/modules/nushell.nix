{pkgs, ...}: {
  home.packages = with pkgs; [
    fzf
    ripgrep
    eza
    ugrep
    yazi
    chafa
    fastfetch
    nix-your-shell
    jq
    argc
    hwinfo
    bubblewrap
  ];

  programs.direnv = {
    enableNushellIntegration = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      prettybat
    ];
  };

  programs.nushell = {
    enable = true;

    shellAliases = {
      zed = "zeditor";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      grep = "ugrep --color=auto";
      journal = "journalctl -p 3 -xb";
    };

    environmentVariables = {
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    };

    settings = {
      show_banner = false;
    };

    extraConfig = let
      nixYourShellNu = pkgs.runCommand "nix-your-shell.nu" {} ''
        ${pkgs.nix-your-shell}/bin/nix-your-shell nu > $out
      '';
    in ''
      def backup [filename: string] {
        cp $filename ($filename + ".bak")
      }

      def pip-freeze [] {
        python -c "from importlib.metadata import distributions
      for d in sorted(distributions(), key=lambda x: x.metadata['Name'].lower()):
          print(f\"{d.metadata['Name']}=={d.version}\")"
      }

      def --wrapped cat [...args] {
        if (is-terminal --stdout) {
          bat --paging=never --style=numbers,changes ...$args
        } else {
          ^cat ...$args
        }
      }

      source ${nixYourShellNu}

      if ("IN_NIX_SHELL" in $env) == false {
        if (which check_and_display | is-empty) {
          fastfetch
        } else {
          check_and_display
        }
      }
    '';
  };
}
