{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  sassc,
  gnome-shell,
  adwaita-icon-theme,
  hicolor-icon-theme,
  colorVariants ? [],
  sizeVariants ? [],
  themeVariants ? [],
  tweakVariants ? [],
  iconVariants ? [],
}: let
  pname = "tokyonight-gtk-theme";
  source = (import ../sources.nix).tokyonight-gtk-theme;
  inherit (source) version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);

  colorVariantList = ["dark" "light"];
  sizeVariantList = ["compact" "standard"];
  themeVariantList = ["default" "green" "grey" "orange" "pink" "purple" "red" "teal" "yellow" "all"];
  tweakVariantList = ["moon" "storm" "black" "float" "outline" "macos"];
  iconVariantList = ["Dark-Cyan" "Dark" "Light" "Moon"];
in
  lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants
  lib.checkListOfEnum "${pname}: sizeVariants"
  sizeVariantList
  sizeVariants
  lib.checkListOfEnum "${pname}: themeVariants"
  themeVariantList
  themeVariants
  lib.checkListOfEnum "${pname}: tweakVariants"
  tweakVariantList
  tweakVariants
  lib.checkListOfEnum "${pname}: iconVariants"
  iconVariantList
  iconVariants
  stdenvNoCC.mkDerivation {
    inherit pname version;
    src = fetchFromGitHub {
      inherit (source) owner repo rev;
      hash = deps.src.hash;
    };
    strictDeps = true;
    nativeBuildInputs = [sassc gnome-shell];
    # Yaru and gnome both removed from nixpkgs along with GTK 2
    propagatedBuildInputs = lib.optionals (iconVariants != []) [
      adwaita-icon-theme
      hicolor-icon-theme
    ];
    dontBuild = true;
    postPatch = ''
      patchShebangs themes/install.sh themes/gtkrc.sh
      substituteInPlace icons/*/index.theme \
        --replace-fail "Inherits=Yaru,gnome,hicolor" "Inherits=Adwaita,hicolor"
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      themes/install.sh -n Tokyonight -d $out/share/themes \
        ${lib.optionalString (colorVariants != []) "-c " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != []) "-s " + toString sizeVariants} \
        ${lib.optionalString (themeVariants != []) "-t " + toString themeVariants} \
        ${lib.optionalString (tweakVariants != []) "--tweaks " + toString tweakVariants}
      ${lib.optionalString (iconVariants != []) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "icons/Tokyonight-${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';
    meta = {
      description = "Tokyo Night GTK theme (mainly to deal with GTK2 removal)";
      homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      maintainers = ["Hibiki"];
      platforms = lib.platforms.linux;
    };
  }
