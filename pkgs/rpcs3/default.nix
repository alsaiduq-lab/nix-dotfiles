{
  fetchFromGitHub,
  rpcs3,
}: let
  source = (import ../sources.nix).rpcs3;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);

  discordRpc = fetchFromGitHub {
    inherit (source) owner repo rev;
    hash = deps.discordRpc.hash;
  };
in
  (rpcs3.override {
    enableDiscordRpc = true;
  }).overrideAttrs (old: {
    preConfigure =
      old.preConfigure
      + ''
        mkdir -p 3rdparty/discord-rpc/discord-rpc
        cp -r ${discordRpc}/. 3rdparty/discord-rpc/discord-rpc/
      '';
  })
