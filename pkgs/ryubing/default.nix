{
  lib,
  buildDotnetModule,
  cctools,
  darwin,
  dotnetCorePackages,
  fetchgit,
  libx11,
  libgdiplus,
  moltenvk,
  ffmpeg,
  openal,
  libsoundio,
  sndio,
  stdenv,
  pulseaudio,
  vulkan-loader,
  glew,
  libGL,
  libice,
  libsm,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  udev,
  SDL2,
  SDL2_mixer,
  gtk3,
  wrapGAppsHook3,
}: let
  source = (import ../sources.nix).ryubing;
  inherit (source) version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  nugetDeps = builtins.map dotnetCorePackages.fetchNupkg deps.nuget;

  # nix lacks the /usr font path expected by the generic SkiaSharp asset
  skiaSharpLinux = lib.head (lib.filter (p: p.pname == "SkiaSharp.NativeAssets.Linux") deps.nuget);
  skiaSharpFontconfig = dotnetCorePackages.fetchNupkg skiaSharpLinux;

  hostRid = dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system;
in
  buildDotnetModule (finalAttrs: {
    pname = "ryubing";
    inherit version;

    src = fetchgit {
      inherit (source) url rev;
      hash = deps.src.hash;
    };

    strictDeps = true;

    nativeBuildInputs =
      lib.optionals stdenv.hostPlatform.isLinux [
        wrapGAppsHook3
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        cctools
        darwin.sigtool
      ];

    enableParallelBuilding = false;

    dotnet-sdk = dotnetCorePackages.sdk_10_0;
    dotnet-runtime = dotnetCorePackages.runtime_10_0;

    inherit nugetDeps;

    runtimeDeps =
      [
        libx11
        libgdiplus
        SDL2_mixer
        openal
        libsoundio
        sndio
        vulkan-loader
        ffmpeg
        glew
        libice
        libsm
        libxcursor
        libxext
        libxi
        libxrandr
        gtk3
        libGL
        SDL2
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        udev
        pulseaudio
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [moltenvk];

    projectFile = "Ryujinx.sln";
    testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
    dotnetFlags = [
      "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
    ];
    doCheck = false;

    executables = [
      "Ryujinx"
    ];

    makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
      "--set SDL_VIDEODRIVER x11"
    ];

    preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/lib/sndio-6
      ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
    '';

    preFixup = ''
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        mkdir -p $out/share/{applications,icons/hicolor/256x256/apps,mime/packages}
        pushd ${finalAttrs.src}/distribution/linux
        install -D ./app.ryujinx.Ryujinx.desktop $out/share/applications/app.ryujinx.Ryujinx.desktop
        install -D ./Ryujinx.sh                   $out/bin/Ryujinx.sh
        install -D ./mime/Ryujinx.xml             $out/share/mime/packages/Ryujinx.xml
        install -D ../misc/Logo.png               $out/share/icons/hicolor/256x256/apps/app.ryujinx.Ryujinx.png
        popd
      ''}
      ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "ln -s $out/bin/Ryujinx $out/bin/ryujinx"}
    '';

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      target=$out/lib/ryubing/runtimes/${hostRid}/native/libSkiaSharp.so
      if [[ ! -e $target ]]; then
        echo "expected $target in publish output, layout changed" >&2
        exit 1
      fi
      install -m644 \
        ${skiaSharpFontconfig}/share/nuget/packages/skiasharp.nativeassets.linux/${skiaSharpLinux.version}/runtimes/${hostRid}/native/libSkiaSharp.so \
        "$target"
    '';

    meta = {
      homepage = "https://ryujinx.app";
      changelog = "https://git.ryujinx.app/ryubing/ryujinx/-/wikis/changelog";
      description = "Experimental Nintendo Switch Emulator written in C# (community fork of Ryujinx)";
      license = lib.licenses.mit;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      maintainers = ["Hibiki"];
      mainProgram = "Ryujinx";
    };
  })
