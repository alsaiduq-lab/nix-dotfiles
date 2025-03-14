{ lib, rustPlatform, fetchgit, ncurses, sphinx, python3 }:
rustPlatform.buildRustPackage rec {
  pname = "fish";
  version = "4.1-2025-03-14-rust";
  src = fetchgit {
    url = "https://github.com/fish-shell/fish-shell.git";
    rev = "refs/heads/master";
    fetchSubmodules = true;
    sha256 = "18zpwa3yddic6wdwj7g51w6n4apwsixfvl179yddk2nwfpxhv4hq";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "pcre2-0.2.9" = "0mhjw7fvrzxb3fd0c534a17qgy6svz0z8269d2fs6q8aw11610mr";
      "pcre2-sys-0.2.9" = "0mhjw7fvrzxb3fd0c534a17qgy6svz0z8269d2fs6q8aw11610mr";
    };
  };
  buildInputs = [ ncurses ];
  nativeBuildInputs = [ sphinx python3 ];
  preBuild = ''
    export FISH_BUILD_VERSION="${version}"
    export FISH_BUILD_DOCS=1
  '';
  postInstall = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/fish/install
    $out/bin/fish --install
    mkdir -p $out/share/fish
    cp -r $HOME/.local/share/fish/install/* $out/share/fish/ 2>/dev/null || true
    mkdir -p $out/share/fish/tools
    cp $src/share/tools/create_manpage_completions.py $out/share/fish/tools/
    cp $src/share/tools/deroff.py $out/share/fish/tools/
    chmod +x $out/share/fish/tools/create_manpage_completions.py
    chmod +x $out/share/fish/tools/deroff.py
    rm -rf $HOME
  '';
  doCheck = false;
  meta = with lib; {
    description = "The user-friendly command line shell (Rust version)";
    homepage = "https://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "fish";
  };
  passthru.shellPath = "/bin/fish";
}
