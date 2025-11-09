{
  pkgs,
  lib,
}:
pkgs.rpcs3.overrideAttrs (oldAttrs: {
  cmakeFlags =
    (oldAttrs.cmakeFlags or [])
    ++ [
      "-DUSE_DISCORD_RPC=ON"
    ];
})
