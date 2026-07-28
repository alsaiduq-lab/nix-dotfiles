{
  pkgs,
  settings,
  ...
}: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = settings.gtkTheme;
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = ["dark"];
        tweakVariants = ["storm"];
      };
    };
    iconTheme = {
      name = settings.iconTheme;
      package = pkgs.magna-glassy-icons;
    };
    gtk3.extraCss = ''
      @import url("dank-colors.css");
    '';
    gtk4.extraCss = ''
      @import url("dank-colors.css");
    '';
  };
}
