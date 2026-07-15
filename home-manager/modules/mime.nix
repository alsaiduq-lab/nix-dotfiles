{settings, ...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "image/*" = "org.kde.gwenview.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/gif" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
      "image/bmp" = "org.kde.gwenview.desktop";
      "image/svg+xml" = "org.kde.gwenview.desktop";
      "image/tiff" = "org.kde.gwenview.desktop";
      "text/html" = "${settings.Browser}.desktop";
      "x-scheme-handler/http" = "${settings.Browser}.desktop";
      "x-scheme-handler/https" = "${settings.Browser}.desktop";
      "application/pdf" = "${settings.Browser}.desktop";
      "video/*" = "mpv.desktop";
      "audio/*" = "mpv.desktop";
      "text/plain" = "${settings.Editor}.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
