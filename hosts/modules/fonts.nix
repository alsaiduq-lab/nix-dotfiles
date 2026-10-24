{
  pkgs,
  settings,
  ...
}: {
  i18n.extraLocales = ["ja_JP.UTF-8/UTF-8"];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      unifont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts._0xproto
      nerd-fonts.noto
      nerd-fonts.symbols-only
      material-symbols
      clear-sans
    ];

    fontDir.enable = true;

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      localConf = ''
        <alias>
          <family>ui-monospace</family>
          <prefer>
            <family>${settings.TerminalFont}</family>
          </prefer>
        </alias>
      '';
      defaultFonts = {
        monospace = [settings.TerminalFont "Noto Sans Mono CJK JP"];
        sansSerif = ["Clear Sans" "Noto Sans CJK JP"];
        serif = ["Noto Serif" "Noto Serif CJK JP"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
