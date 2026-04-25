{
  pkgs,
  updateDeps,
}: let
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  discordRpcSrc = pkgs.fetchFromGitHub {
    owner = "Vestrel";
    repo = "discord-rpc";
    rev = "master";
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
          owner = "Vestrel";
          repo = "discord-rpc";
          rev = "master";
          key = "discordRpc";
          maintainer = "Hibiki";
        };
      };

    preConfigure = ''
      mkdir -p 3rdparty/discord-rpc/discord-rpc
      cp -r ${discordRpcSrc}/* 3rdparty/discord-rpc/discord-rpc/
    '';
  })
