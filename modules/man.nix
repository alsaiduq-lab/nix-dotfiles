{ config, pkgs, lib, ... }:
{
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    nixos.enable = true;
  };

  environment.pathsToLink = [ "/share/man" "/share/doc" ];

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    stdmanpages
    docutils
    python311Packages.docutils
    python311Packages.docstr-coverage
    python310Packages.docutils
    python310Packages.docstr-coverage
    texlivePackages.documentation
    docbook5
    docbook-xsl-ns
    docbook-xsl-nons
    doctoc
    doctave
    documentation-highlighter
  ];

  environment.variables = {
    MANPATH = [
      "${config.system.path}/share/man"
      "${pkgs.man-pages}/share/man"
      "${pkgs.man-pages-posix}/share/man"
    ];
  };
}
