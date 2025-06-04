{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nerd-fonts._0xproto
      nerd-fonts.noto
      nerd-fonts.symbols-only
      ipafont
      kochi-substitute
      clear-sans
      binary-font
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["0xProto Nerd Font" "Noto Sans Mono CJK JP"];
        sansSerif = ["Clear Sans" "Noto Sans CJK JP"];
        serif = ["Noto Serif" "Noto Serif CJK JP"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
