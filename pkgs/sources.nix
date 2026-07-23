{
  clear-sans = {
    kind = "github";
    version = "1.0";
    locked = true;
    owner = "intel";
    repo = "clear-sans";
    rev = "main";
  };

  dms-lyrics-on-panel = {
    kind = "github";
    version = "unstable";
    owner = "KangweiZhu";
    repo = "lyrics-on-panel";
    rev = "main";
  };

  minijinja-cli = {
    kind = "rustCrate";
    version = "2.20.0";
    locked = true;
    pname = "minijinja-cli";
  };

  rpcs3 = {
    kind = "github";
    owner = "Vestrel";
    repo = "discord-rpc";
    rev = "master";
    key = "discordRpc";
  };

  ryubing = {
    kind = "dotnet";
    version = "1.3.335";
    locked = true;
    url = "https://git.ryujinx.app/projects/Ryubing.git";
    rev = "Canary-{version}";
    projectFile = "Ryujinx.sln";
    testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
    dotnetSdk = "sdk_10_0";
    dotnetFlags = [
      "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };

  thorium = {
    kind = "url";
    version = "144.0.7559.254";
    url = "https://github.com/gz83/thorium/releases/download/M144.0.7559.254/thorium-browser_144.0.7559.254_AVX2.deb";
    latest = {
      url = "https://api.github.com/repos/gz83/thorium/releases?per_page=1";
      query = ''.[0].tag_name | ltrimstr("M")'';
    };
  };

  vita3k = {
    kind = "githubAsset";
    version = "3967";
    locked = true;
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/3967/Vita3K-x86_64.AppImage";
  };

  proton-ge-11-1 = {
    kind = "url";
    version = "GE-Proton11-1";
    locked = true;
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz";
  };

  magna-glassy-icons = {
    kind = "github";
    version = "unstable";
    owner = "L4ki";
    repo = "Magna-Plasma-Themes";
    rev = "main";
  };
}
