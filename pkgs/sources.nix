{
  rpcs3 = {
    kind = "sourceBuild";
    owner = "Vestrel";
    repo = "discord-rpc";
    rev = "master";
  };

  ryubing = {
    kind = "sourceBuild";
    version = "1.3.335";
    url = "https://git.ryujinx.app/projects/Ryubing.git";
    rev = "Canary-1.3.335";
  };

  thorium = {
    kind = "url";
    version = "150.0.7871.101";
    url = "https://github.com/gz83/thorium/releases/download/M150.0.7871.101/thorium-browser_150.0.7871.101_AVX2.deb";
  };

  vita3k = {
    kind = "url";
    version = "3967";
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/3967/Vita3K-x86_64.AppImage";
  };

  proton-ge-11 = {
    kind = "url";
    version = "GE-Proton11-3";
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-3/GE-Proton11-3.tar.gz";
  };

  magna-glassy-icons = {
    kind = "sourceBuild";
    version = "unstable";
    owner = "L4ki";
    repo = "Magna-Plasma-Themes";
    rev = "main";
  };

  tokyonight-gtk-theme = {
    kind = "sourceBuild";
    version = "unstable";
    owner = "Fausto-Korpsvart";
    repo = "Tokyonight-GTK-Theme";
    rev = "master";
  };
}
