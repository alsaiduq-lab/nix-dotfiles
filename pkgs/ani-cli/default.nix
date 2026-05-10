{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  gnugrep,
  gnused,
  curl,
  fzf,
  aria2,
  yt-dlp,
  ffmpeg,
  openssl,
  mpv,
  vlc,
  syncplay,
  catt,
  updateDeps,
}: let
  pname = "ani-cli";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  version = deps.version;
  source = {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
  };
  runtimeInputs = [
    gnugrep
    gnused
    curl
    fzf
    aria2
    yt-dlp
    ffmpeg
    openssl
    mpv
    vlc
    syncplay
    catt
  ];
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub (source
      // {
        hash = deps.src.hash;
      });

    nativeBuildInputs = [makeWrapper];

    passthru = {
      depsFile = "pkgs/ani-cli/deps.json";
      "update-deps" = updateDeps.fetchFromGitHub (source
        // {
          inherit version;
          name = pname;
        });
    };

    installPhase = ''
      runHook preInstall

      install -Dm755 ani-cli $out/bin/ani-cli
      patchShebangs $out/bin/ani-cli

      wrapProgram $out/bin/ani-cli \
        --prefix PATH : ${lib.makeBinPath runtimeInputs}

      runHook postInstall
    '';

    meta = {
      description = "Ad-free anime watching from the terminal";
      homepage = "https://github.com/pystardust/ani-cli";
      license = lib.licenses.gpl3Plus;
      mainProgram = "ani-cli";
      maintainers = ["Hibiki"];
      platforms = lib.platforms.unix;
    };
  }
