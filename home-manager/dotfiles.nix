{
  lib,
  config,
  pkgs,
  hyprlanddots,
  nvimDots,
  ...
}: {
  options.dotfiles.files = lib.mkOption {
    default = {};
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        from = lib.mkOption {
          type = lib.types.str;
        };
        to = lib.mkOption {
          type = lib.types.str;
        };
      };
    });
  };

  options.dotfiles.quickshell = lib.mkOption {
    default = null;
    type = lib.types.nullOr (lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        from = lib.mkOption {
          type = lib.types.str;
        };
        marker = lib.mkOption {
          type = lib.types.str;
        };
        name = lib.mkOption {
          type = lib.types.str;
        };
      };
    });
  };

  config.dotfiles.files = {
    fish = {
      from = lib.mkDefault "${hyprlanddots}/fish/";
      to = lib.mkDefault "fish/";
    };

    hypr = {
      from = lib.mkDefault "${hyprlanddots}/hypr/";
      to = lib.mkDefault "hypr/";
    };

    cava = {
      from = lib.mkDefault "${hyprlanddots}/cava/";
      to = lib.mkDefault "cava/";
    };

    nvim = {
      from = lib.mkDefault "${nvimDots}/";
      to = lib.mkDefault "nvim/";
    };

    starship = {
      from = lib.mkDefault "${hyprlanddots}/starship.toml";
      to = lib.mkDefault "starship.toml";
    };

    # Example only when a source has hardcoded script shebangs:
    #
    # scripts = {
    #   from = lib.mkDefault "${pkgs.runCommand "dotfiles-scripts" {} ''
    #     mkdir -p "$out"
    #     cp -a ${hyprlanddots}/scripts/. "$out/"
    #     chmod -R u+w "$out"
    #     patchShebangs "$out"
    #   ''}/";
    #   to = lib.mkDefault "scripts/";
    # };
  };

  config.dotfiles.quickshell = lib.mkIf (lib.attrByPath ["programs" "dms-shell" "enable"] false config) {
    from = lib.mkDefault "${pkgs.dms-shell}/share/quickshell/dms";
    marker = lib.mkDefault "DMSShell.qml";
    name = lib.mkDefault "dms";
  };
}
