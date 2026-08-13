{
  pkgs,
  settings,
  ...
}: {
  gtk = {
    enable = true;
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
    gtk3 = {
      colorScheme = "dark";
      extraCss = ''
        @import url("dank-colors.css");
      '';
    };
    gtk4 = {
      theme = {
        name = settings.gtkTheme;
        package = pkgs.tokyonight-gtk-theme.override {
          colorVariants = ["dark"];
          tweakVariants = ["storm"];
        };
      };
      extraConfig = {
        gtk-interface-color-scheme = "dark";
      };
      extraCss = ''
        @import url("dank-colors.css");
      '';
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;
}
