{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  kdePackages,
  hicolor-icon-theme,
  updateDeps,
}: let
  pname = "magna-glassy-icons";
  version = "unstable";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  source = {
    owner = "L4ki";
    repo = "Magna-Plasma-Themes";
    rev = "main";
  };
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub (source
      // {
        hash = deps.src.hash;
      });

    strictDeps = true;
    dontWrapQtApps = true;

    nativeBuildInputs = [gtk3];
    propagatedBuildInputs = [kdePackages.breeze-icons hicolor-icon-theme];

    dontDropIconThemeCache = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons
      cp -a \
        "Magna Icons Themes/Magna-Glassy-Dark-Icons" \
        "Magna Icons Themes/Magna-Glassy-Light-Icons" \
        $out/share/icons/

      for theme in $out/share/icons/*; do
        rm -f "$theme/icon-theme.cache"
        find "$theme" -name " *" -delete
        gtk-update-icon-cache --force "$theme"
        test -f "$theme/icon-theme.cache"
      done

      runHook postInstall
    '';

    meta = {
      description = "Magna Glassy icon themes (dark and light) by L4ki";
      homepage = "https://github.com/L4ki/Magna-Plasma-Themes";
      license = lib.licenses.gpl3Only;
      maintainers = ["Hibiki"];
      platforms = lib.platforms.linux;
    };
  }
