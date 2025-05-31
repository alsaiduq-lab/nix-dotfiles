{pkgs, ...}: {
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
    ];
  };
}
