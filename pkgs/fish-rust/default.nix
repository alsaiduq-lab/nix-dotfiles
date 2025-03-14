{ lib, rustPlatform, fetchgit, pkg-config, cmake, ncurses, sphinx }:

rustPlatform.buildRustPackage rec {
  pname = "fish";
  version = "unstable-2025-03-14";

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

  nativeBuildInputs = [ pkg-config cmake sphinx ];
  buildInputs = [ ncurses ];

  preBuild = ''
    export FISH_BUILD_VERSION="${version}"
    export FISH_BUILD_DOCS=1
  '';

  doCheck = false;

  meta = with lib; {
    description = "The user-friendly command line shell (Rust version)";
    homepage = "https://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
