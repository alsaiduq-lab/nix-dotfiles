{pkgs, ...}: let
  rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/RPCS3/rpcs3.git";
      ref = "master";
    };
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
    (
      if (builtins.tryEval rpcs3_latest).success
      then rpcs3_latest
      else rpcs3
    )
    # uses latest commit, but in case of errors (if there were any in the first place) to fallback to snapshot nix package in case it failed (even if not)
  ];
}
