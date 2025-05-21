{
  lib,
  rustPlatform,
  fetchgit,
  ncurses,
  python3Packages,
  gettext,
  coreutils,
  findutils,
  gawk,
  groff,
  xsel,
}:
rustPlatform.buildRustPackage rec {
  pname = "fish";
  version = "4.0.2-2025-04-20-${builtins.substring 0 7 "489d5d1733de5d10328e948c7683da198c5859c0"}";

  src = fetchgit {
    url = "https://github.com/fish-shell/fish-shell.git";
    rev = "489d5d1733de5d10328e948c7683da198c5859c0";
    fetchSubmodules = true;
    sha256 = "sha256-Q0sGAIjsvQsjvAnZlcyB2VldOpmiBYPliF5uyOndyyA=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "pcre2-0.2.9" = "0mhjw7fvrzxb3fd0c534a17qgy6svz0z8269d2fs6q8aw11610mr";
      "pcre2-sys-0.2.9" = "0mhjw7fvrzxb3fd0c534a17qgy6svz0z8269d2fs6q8aw11610mr";
    };
  };

  buildInputs = [
    ncurses
    gettext
    coreutils
    findutils
    gawk
    groff
    xsel
  ];
  nativeBuildInputs = with python3Packages; [
    sphinx
    sphinx_rtd_theme
    python
  ];

  preBuild = ''
    export FISH_BUILD_VERSION="${version}"
    export FISH_BUILD_DOCS=1
  '';

  postInstall = ''
    mkdir -p $out/share/fish/tools
    cp $src/share/tools/create_manpage_completions.py $out/share/fish/tools/
    cp $src/share/tools/deroff.py $out/share/fish/tools/
    chmod +x $out/share/fish/tools/create_manpage_completions.py
    chmod +x $out/share/fish/tools/deroff.py
  '';

  doCheck = false;

  meta = with lib; {
    description = "The user-friendly command line shell (Rust version)";
    homepage = "https://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "fish";
    maintainers = ["Cobray"];
  };

  passthru.shellPath = "/bin/fish";
}
