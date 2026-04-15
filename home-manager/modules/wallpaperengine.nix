{pkgs, ...}: {
  home.packages = [
    (pkgs.linux-wallpaperengine.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          sed -i '/wl_surface_set_buffer_scale (viewport->cursorSurface/d' \
            src/WallpaperEngine/Render/Drivers/WaylandOpenGLDriver.cpp
          sed -i '/wl_surface_attach (viewport->cursorSurface/d' \
            src/WallpaperEngine/Render/Drivers/WaylandOpenGLDriver.cpp
          sed -i '/wl_pointer_set_cursor (/,/);/d' \
            src/WallpaperEngine/Render/Drivers/WaylandOpenGLDriver.cpp
          sed -i '/wl_surface_commit (viewport->cursorSurface);/d' \
            src/WallpaperEngine/Render/Drivers/WaylandOpenGLDriver.cpp
        '';
    }))
  ];
}
