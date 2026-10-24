{
  lib,
  pkgs,
  settings,
  ...
}: let
  associations = desktopFile: desktopName: let
    mimeLine =
      lib.findFirst
      (line: lib.hasPrefix "MimeType=" line)
      (throw "no MimeType= line in ${desktopFile}")
      (lib.splitString "\n" (builtins.readFile desktopFile));
  in
    lib.genAttrs
    (lib.filter (type: type != "") (lib.splitString ";" (lib.removePrefix "MimeType=" mimeLine)))
    (_: desktopName);
in {
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      associations "${pkgs.mpv}/share/applications/mpv.desktop" "mpv.desktop"
      // associations "${pkgs.kdePackages.gwenview}/share/applications/org.kde.gwenview.desktop" "org.kde.gwenview.desktop"
      // {
        "inode/directory" = "org.kde.dolphin.desktop";
        "text/html" = "${settings.Browser}.desktop";
        "x-scheme-handler/http" = "${settings.Browser}.desktop";
        "x-scheme-handler/https" = "${settings.Browser}.desktop";
        "application/pdf" = "${settings.Browser}.desktop";
        "text/plain" = "${settings.Editor}.desktop";
      };
  };

  xdg.configFile."mimeapps.list".force = true;
}
