{settings, ...}: {
  # used to share desktop/laptop configs
  xresources.properties = {
    "Xcursor.theme" = settings.cursorName;
    "Xcursor.size" = settings.cursorSize;
  };
}
