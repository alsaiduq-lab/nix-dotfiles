{
  pkgs,
  updateDeps,
}: let
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
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
  pkgs.rpcs3.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.pipewire.jack
    ];

    cmakeFlags =
      oldAttrs.cmakeFlags
      ++ [
        "-DUSE_DISCORD_RPC=ON"
      ];

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
