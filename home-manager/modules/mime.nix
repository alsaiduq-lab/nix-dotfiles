{config, ...}: {
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
      "text/html" = "${config.theme.Browser}.desktop";
      "x-scheme-handler/http" = "${config.theme.Browser}.desktop";
      "x-scheme-handler/https" = "${config.theme.Browser}.desktop";
      "application/pdf" = "${config.theme.Browser}.desktop";
      "video/*" = "mpv.desktop";
      "audio/*" = "mpv.desktop";
      "text/plain" = "${config.theme.Editor}.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
