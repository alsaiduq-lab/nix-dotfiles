{
  pkgs,
  updateDeps,
}: let
  deps = builtins.fromJSON (builtins.readFile ./deps.json);

  glewGlx = pkgs.glew.override {
    enableEGL = false;
  };

  discordRpc = {
    owner = "Vestrel";
    repo = "discord-rpc";
    rev = "master";
  };

  discordRpcSrc = pkgs.fetchFromGitHub {
    inherit (discordRpc) owner repo rev;
    hash = deps.discordRpc.hash;
  };
in
  (pkgs.rpcs3.override {
    glew = glewGlx;
  }).overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.pipewire.jack
    ];

    cmakeFlags =
      oldAttrs.cmakeFlags
      ++ [
        "-DUSE_DISCORD_RPC=ON"
      ];

    postPatch = (oldAttrs.postPatch or "") + ''
      ${pkgs.python3}/bin/python3 - <<'PY'
      import re
      from pathlib import Path

      p = Path("rpcs3/CMakeLists.txt")
      s = p.read_text()

      glew = "${pkgs.lib.getLib glewGlx}/lib/libGLEW.so"

      s, n = re.subn(
          r"target_link_libraries\(rpcs3\s+PRIVATE\s+rpcs3_lib\s*(?:.*?\s*)?\)",
          f"target_link_libraries(rpcs3 PRIVATE\n\trpcs3_lib\n\t-Wl,--push-state,--no-as-needed\n\t{glew}\n\t-Wl,--pop-state\n)",
          s,
          count=1,
          flags=re.S,
      )

      if n != 1:
          raise SystemExit("failed to patch rpcs3 GLEW link")

      p.write_text(s)
      PY
    '';

    passthru =
      (oldAttrs.passthru or {})
      // {
        depsFile = "pkgs/rpcs3/deps.json";
        "update-deps" = updateDeps.fetchFromGitHub {
          name = "rpcs3-discord-rpc";
          inherit (discordRpc) owner repo rev;
          key = "discordRpc";
        };
      };

    meta =
      (oldAttrs.meta or {})
      // {
        maintainers = pkgs.lib.unique ((oldAttrs.meta.maintainers or []) ++ ["Hibiki"]);
      };

    preConfigure = ''
      mkdir -p 3rdparty/discord-rpc/discord-rpc
      cp -r ${discordRpcSrc}/* 3rdparty/discord-rpc/discord-rpc/
    '';
  })
