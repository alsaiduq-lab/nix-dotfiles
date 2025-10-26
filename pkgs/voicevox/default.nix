{
  lib,
  stdenv,
  fetchurl,
  p7zip,
  appimage-run,
  makeWrapper,
}: let
  version = "0.24.1";
  pname = "voicevox";
  hashes = {
    "001" = "sha256-zkdrx7if0Q8n5H8g7T1IfCt6F9w3a/3ksGP5rO0rLqw=";
    "002" = "sha256-rpkhQW+DqMcXIsrdKNbjw8llfRgR3aLPJsBIMybIJ9A=";
    "003" = "sha256-c2PgGVT0LwyNsEB3RFqw4joO8FlMTzpE4FksRzYjRJs=";
  };
  mkSrc = part:
    fetchurl {
      url = "https://github.com/VOICEVOX/voicevox/releases/download/${version}/VOICEVOX.AppImage.7z.${part}";
      hash = hashes.${part};
    };
in
  stdenv.mkDerivation {
    inherit pname version;
    srcs = map mkSrc ["001" "002" "003"];
    nativeBuildInputs = [p7zip makeWrapper];
    dontUnpack = true;
    buildPhase = ''
      cp ${mkSrc "001"} VOICEVOX.AppImage.7z.001
      cp ${mkSrc "002"} VOICEVOX.AppImage.7z.002
      cp ${mkSrc "003"} VOICEVOX.AppImage.7z.003
      7z x VOICEVOX.AppImage.7z.001
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/voicevox
      install -Dm755 VOICEVOX.AppImage $out/share/voicevox/VOICEVOX.AppImage
      makeWrapper ${appimage-run}/bin/appimage-run $out/bin/voicevox \
        --add-flags "$out/share/voicevox/VOICEVOX.AppImage" \
        --set APPIMAGE_EXTRACT_AND_RUN 1 \
        --set NIXOS_OZONE_WL 1 \
        --unset ELECTRON_OZONE_PLATFORM_HINT \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
    '';

    meta = with lib; {
      description = "無料で使える中品質なテキスト読み上げ・歌声合成ソフトウェア";
      homepage = "https://voicevox.hiroshiba.jp/";
      license = licenses.lgpl3Plus;
      platforms = ["x86_64-linux"];
      mainProgram = "voicevox";
      maintainers = ["アルテウル シュタインベック"];
    };
  }
