# might just rename to just discord-rpc?
{
  pkgs,
  lib,
}:
pkgs.rpcs3.overrideAttrs (oldAttrs: {
  cmakeFlags =
    oldAttrs.cmakeFlags
    ++ [
      "-DUSE_DISCORD_RPC=ON"
    ];
  buildInputs = oldAttrs.buildInputs ++ [pkgs.pipewire.jack];
  preConfigure = ''
    mkdir -p 3rdparty/discord-rpc/discord-rpc
    cp -r ${pkgs.fetchFromGitHub {
      owner = "Vestrel";
      repo = "discord-rpc";
      rev = "master";
      hash = "sha256-+fxpMmCOhv6GBSDqS2xc3KSw4UFIVgHkWbVz5b/KiBg=";
    }}/* 3rdparty/discord-rpc/discord-rpc/
  '';
})
