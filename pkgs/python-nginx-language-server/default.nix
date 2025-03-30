{
  lib,
  python311Packages,
  fetchFromGitHub,
}: let
  cusPydantic = python311Packages.pydantic.overridePythonAttrs (oldAttrs: rec {
    version = "1.10.18";
    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic";
      rev = "v${version}";
      sha256 = "PiYl6hcpzJoKF/rssCunF6xuCHLWfgZUQxD2wkAbLH4=";
    };
    doCheck = false;
  });
in
  python311Packages.buildPythonPackage rec {
    pname = "nginx-language-server";
    version = "0.8.0";
    format = "pyproject";
    src = fetchFromGitHub {
      owner = "pappasam";
      repo = "nginx-language-server";
      rev = "v${version}";
      sha256 = "AXWrNt4f3jkAbidE1goDgFicu4sSBv08f/Igyh2bRII=";
    };
    nativeBuildInputs = with python311Packages; [
      setuptools
      poetry-core
    ];
    propagatedBuildInputs = with python311Packages; [
      pygls
      cusPydantic
      crossplane
      lsprotocol
    ];
    pythonImportsCheck = ["nginx_language_server"];
    doCheck = false;
    meta = with lib; {
      description = "A language server for nginx";
      homepage = "https://github.com/pappasam/nginx-language-server";
      license = licenses.gpl3Only;
      platforms = platforms.all;
      maintainers = with maintainers; ["Cobray"];
    };
  }
