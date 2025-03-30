{
  lib,
  python311Packages,
  fetchFromGitHub,
  pkgs,
}: let
  cusPydantic = python311Packages.buildPythonPackage {
    pname = "pydantic";
    version = "1.10.18";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/py3/p/pydantic/pydantic-1.10.18-py3-none-any.whl";
      sha256 = "10iaggdy69wk6qkagqcnlsqchrsidvqhgh68r5p78lpw3yw8k886";
    };
    doCheck = false;
    propagatedBuildInputs = with python311Packages; [
      typing-extensions
    ];
  };
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
