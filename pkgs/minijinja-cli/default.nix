{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "minijinja-cli";
  version = "2.11.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HPocm+dEV5dBJqjYedylTGHhm2iPHjZzg2mvuFgaDCY=";
  };

  cargoHash = "sha256-4ZYbB/tAzTOryBZKBoMKFNDC3CpWA92t1nfJHwMDlUg=";

  doCheck = false;

  meta = with lib; {
    description = "Command-line renderer for MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = licenses.asl20;
    mainProgram = "minijinja";
    platforms = platforms.unix;
    maintainer = "Cobray";
  };
}
