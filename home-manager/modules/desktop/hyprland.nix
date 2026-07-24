{
  lib,
  settings,
  ...
}: let
  toLua = lib.generators.toLua {};

  cursor = {
    no_hardware_cursors = 2; # auto
    use_cpu_buffer = 2;
  };

  xwayland = {
    force_zero_scaling = true;
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    force_default_wallpaper = 0;
    vrr = 1;
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;
    middle_click_paste = false;
  };

  input = {
    kb_layout = "us";
    follow_mouse = 1;
    sensitivity = 0;
    touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
    };
  };

  general = {
    gaps_in = 3;
    gaps_out = 12;
    border_size = 2;
    col = {
      active_border = {
        colors = [
          "rgba(f7768eff)"
          "rgba(ff9e64ff)"
          "rgba(e0af68ff)"
          "rgba(9ece6aff)"
          "rgba(73daca99)"
          "rgba(7dcfffff)"
          "rgba(9d7cd8ee)"
          "rgba(bb9af7ee)"
          "rgba(f7768eff)"
        ];
        angle = 45;
      };
      inactive_border = "rgba(3b4261cc)";
    };
    layout = "master";
    resize_on_border = true;
    extend_border_grab_area = 15;
  };

  decoration = {
    rounding = 10;
    blur = {
      enabled = true;
      size = 3;
      passes = 2;
      ignore_opacity = true;
      new_optimizations = true;
    };
    shadow = {
      enabled = true;
      range = 25;
      render_power = 3;
      color = lib.generators.mkLuaInline ''"rgba(1f2335dd)"'';
      offset = [0 8];
    };
    dim_inactive = true;
    dim_strength = 0.1;
  };

  animations = ''
    hl.curve("smooth", { type = "bezier", points = {{0.23, 1}, {0.32, 1 }}})
    hl.curve("fluid", { type = "bezier", points = {{0.4, 0}, {0.2, 1 }}})
    hl.curve("linear", { type = "bezier", points = {{0, 0}, {1, 1 }}})

    hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "fluid", style = "popin 10%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "fluid", style = "popin 10%" })
    hl.animation({ leaf = "layers", enabled = true, speed = 5, bezier = "fluid", style = "fade" })
    hl.animation({ leaf = "fadeLayers", enabled = true, speed = 7, bezier = "smooth" })
    hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "smooth" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "once", })
    hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "smooth" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "fluid", style = "slide" })
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "fluid",  style = "slidevert" })
  '';

  env = ''
    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("XDG_SESSION_DESKTOP", "Hyprland")
    hl.env("NIXOS_OZONE_WL", "1")
    hl.env("QT_QPA_PLATFORM", "wayland;xcb")
    hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
    hl.env("MOZ_ENABLE_WAYLAND", "1")
    hl.env("CLUTTER_BACKEND", "wayland")
    hl.env("GDK_BACKEND", "wayland,x11,*")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("GBM_BACKEND", "nvidia-drm")
    hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
    hl.env("QT_QPA_PLATFORMTHEME", "${settings.qtTheme}")
    hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")
    hl.env("HYPRCURSOR_THEME", "${settings.cursorName}")
    hl.env("HYPRCURSOR_SIZE", "${toString settings.cursorSize}")
    hl.env("XCURSOR_THEME", "${settings.cursorName}")
    hl.env("XCURSOR_SIZE", "${toString settings.cursorSize}")

    hl.config({ cursor = ${toLua cursor} })
    hl.config({ xwayland = ${toLua xwayland} })
    hl.config({ misc = ${toLua misc} })
    hl.config({ input = ${toLua input} })
  '';

  monitors = ''
    hl.monitor({
      output = "DP-3",
      mode = "3440x1440@180",
      position  = "0x0",
      scale = 1.25,
      bitdepth = 8,
    })
  '';

  windows = ''
    hl.window_rule({
      match = { class = "com.mitchellh.ghostty" },
      opacity = "0.9 override 0.7 override 0.9 override",
    })

    hl.window_rule({
      match = { title = "ilgwg_desktop_gremlins.py" },
      no_blur = true,
      no_shadow = true,
      no_dim = true,
      no_anim = true,
      border_size = 0,
    })

    hl.config({ general = ${toLua general} })
    hl.config({ decoration = ${toLua decoration} })
  '';

  autostart = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("dms run")
      hl.exec_cmd("nm-applet --indicator")
      hl.exec_cmd("blueman-applet")
      hl.exec_cmd("syshud")
      hl.exec_cmd("QT_QPA_PLATFORM=wayland linux-desktop-gremlin cafe")
      hl.exec_cmd("udiskie --automount --notify")
    end)
  '';

  keybindings = ''
    local mod = "SUPER"

    hl.bind(mod .. " + Return", hl.dsp.exec_cmd(os.getenv("TERMINAL")))
    hl.bind(mod .. " + B", hl.dsp.exec_cmd(os.getenv("BROWSER")))
    hl.bind(mod .. " + E", hl.dsp.exec_cmd(os.getenv("EDITOR")))
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("sh -lc 'dms ipc call dash open overview'"))
    hl.bind(mod .. " + M", hl.dsp.exec_cmd("sh -lc 'dms ipc call dash toggle media'"))
    hl.bind(mod .. " + L", hl.dsp.exec_cmd("sh -lc 'dms ipc call spotlight toggleQuery \"\"'"))

    for i = 1, 10 do
      local key = i % 10
      hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
      hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
    hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

    hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
    hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + Q", hl.dsp.window.close())
    hl.bind("ALT + F4", hl.dsp.exec_cmd("~/.config/hypr/scripts/altf4.sh"))

    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh annotate"))
    hl.bind("SHIFT + CTRL + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh fullscreen"))
    hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/screen-record.sh"))
    hl.bind(mod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/screen-record.sh region"))

    hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("hyprctl reload && dms restart"))
    hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("sh -lc 'dms ipc call lock lock'"))
    hl.bind(mod .. " + F5", hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode.sh"))

    hl.bind("F7", hl.dsp.exec_cmd("dms ipc mpris previous"))
    hl.bind("F8", hl.dsp.exec_cmd("dms ipc mpris playPause"))
    hl.bind("F9", hl.dsp.exec_cmd("dms ipc mpris next"))
    hl.bind("F10", hl.dsp.exec_cmd("dms ipc audio mute"))
    hl.bind("F11", hl.dsp.exec_cmd("dms ipc audio decrement"), { repeating = true })
    hl.bind("F12", hl.dsp.exec_cmd("dms ipc audio increment"), { repeating = true })

    local function zoom(factor)
      local z = hl.get_config("cursor.zoom_factor")
      local new = z * factor
      if new < 1 then new = 1 end
      hl.config({ cursor = { zoom_factor = new } })
    end

    local function zoom_reset()
      hl.config({ cursor = { zoom_factor = 1 } })
    end

    hl.bind(mod .. " + mouse_down", function() zoom(1.1) end)
    hl.bind(mod .. " + mouse_up", function() zoom(0.9) end)
    hl.bind(mod .. " + equal", function() zoom(1.1) end, { repeating = true })
    hl.bind(mod .. " + minus", function() zoom(0.9) end, { repeating = true })
    hl.bind(mod .. " + KP_ADD", function() zoom(1.1) end, { repeating = true })
    hl.bind(mod .. " + KP_SUBTRACT", function() zoom(0.9) end, { repeating = true })
    hl.bind(mod .. " + SHIFT + mouse_up", zoom_reset)
    hl.bind(mod .. " + SHIFT + mouse_down", zoom_reset)
    hl.bind(mod .. " + SHIFT + 0", zoom_reset)
  '';
in {
  xdg.configFile."hypr/hyprland.lua".text = ''
    require("env")
    require("monitors")
    require("animations")
    require("windows")
    require("keybindings")
    require("autostart")
    require("dms.colors")
    require("dms.layout")
    require("dms.outputs")
  '';

  xdg.configFile."hypr/env.lua".text = env;
  xdg.configFile."hypr/monitors.lua".text = monitors;
  xdg.configFile."hypr/animations.lua".text = animations;
  xdg.configFile."hypr/windows.lua".text = windows;
  xdg.configFile."hypr/keybindings.lua".text = keybindings;
  xdg.configFile."hypr/autostart.lua".text = autostart;
}
