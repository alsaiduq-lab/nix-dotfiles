{
  lib,
  rustPlatform,
  fetchCrate,
}: let
  source = (import ../sources.nix).minijinja-cli;
  inherit (source) pname version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchCrate {
      inherit pname version;
      hash = deps.src.hash;
    };

    cargoHash = deps.cargo.hash;

    strictDeps = true;
    doCheck = false;

    meta = {
      description = "Command-line renderer for MiniJinja/Jinja2 templates";
      homepage = "https://github.com/mitsuhiko/minijinja";
      license = lib.licenses.asl20;
      mainProgram = "minijinja";
      platforms = lib.platforms.unix;
      maintainers = ["Hibiki"];
    };
  }
