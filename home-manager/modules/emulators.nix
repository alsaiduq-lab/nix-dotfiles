{
  pkgs,
  inputs,
  ...
}: let
  rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
    src = inputs.rpcs3-latest;
  });
in {
  home.packages = with pkgs; [
    mgba
    desmume
    duckstation
    pcsx2
    ryujinx
    mupen64plus
    dolphin-emu
    retroarch
    mednafen
    joycond
    # uses latest commit, but in case of errors (if there were any in the first place) to fallback to snapshot nix package in case it failed (even if not)
    (
      if (builtins.tryEval rpcs3_latest).success
      then rpcs3_latest
      else rpcs3
    )
  ];
}
