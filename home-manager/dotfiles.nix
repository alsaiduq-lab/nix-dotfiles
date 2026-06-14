{
  lib,
  config,
  pkgs,
  hyprlanddots,
  nvimDots,
  tokyo-night,
  modernx,
  anime4k,
  ...
}: {
  options.dotfiles = lib.mkOption {
    default = {};
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf (lib.types.submodule {
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
          files = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
          };
        };
      });
    };
  };

  config.dotfiles = {
    nvim = {
      from = lib.mkDefault "${nvimDots}/";
      to = lib.mkDefault "nvim/";
    };
    tokyo-storm-fish-theme = {
      from = lib.mkDefault "${tokyo-night}/extras/fish/tokyonight_storm.fish";
      to = lib.mkDefault "fish/conf.d/tokyonight_storm.fish";
    };
    tokyo-storm-btop-theme = {
      from = lib.mkDefault "${tokyo-night}/extras/btop/tokyonight_storm.theme";
      to = lib.mkDefault "btop/themes/";
    };
    eza-theme = {
      from = lib.mkDefault "${tokyo-night}/extras/eza/tokyonight_moon.yml";
      to = lib.mkDefault "eza/theme.yml";
    };
    yazi-theme = {
      from = lib.mkDefault "${tokyo-night}/extras/yazi/tokyonight_storm.toml";
      to = lib.mkDefault "yazi/theme.toml";
    };
    zellij-theme = {
      from = lib.mkDefault "${tokyo-night}/extras/zellij/tokyonight_moon.kdl";
      to = lib.mkDefault "zellij/theme/";
    };
    modernx = {
      from = lib.mkDefault "${modernx}";
      to = lib.mkDefault "mpv/";
      files = {
        "modernx.lua" = "scripts/modernx.lua";
        "Material-Design-Iconic-Font.ttf" = "fonts/Material-Design-Iconic-Font.ttf";
      };
    };
    anime4k = {
      from = lib.mkDefault "${anime4k}/glsl/";
      to = lib.mkDefault "mpv/shaders/";
    };
  };
}
