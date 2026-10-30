{config, ...}: {
  xdg = {
    enable = true;
    configFile."wget/wgetrc".text = ''
      hsts-file = ${config.xdg.dataHome}/wget-hsts
    '';
  };

  home = {
    preferXdgDirectories = true;
    sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      HISTFILE = "${config.xdg.stateHome}/bash/history";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
      CODEX_HOME = "${config.xdg.configHome}/codex";
      CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
      EASYOCR_MODULE_PATH = "${config.xdg.configHome}/EasyOCR";
      MPLAYER_HOME = "${config.xdg.configHome}/mplayer";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
    };

    shellAliases = {
      wget = ''wget --hsts-file="${config.xdg.dataHome}/wget-hsts"'';
      adb = ''HOME="${config.xdg.dataHome}/android" adb'';
      nvidia-settings = ''nvidia-settings --config="${config.xdg.configHome}/nvidia/settings"'';
    };
  };
}
