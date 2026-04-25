{
  lib,
  rustPlatform,
  fetchCrate,
  updateDeps,
}: let
  pname = "minijinja-cli";
  version = "2.11.0";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchCrate {
      inherit pname version;
      hash = deps.src.hash;
    };

    cargoHash = deps.cargo.hash;

    passthru = {
      depsFile = "pkgs/minijinja-cli/deps.json";
      "update-deps" = updateDeps.fetchCrateRustPackage {
        name = pname;
        inherit pname version;
      };
    };

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
