{
  updateDeps,
}: {
  ani-cli = {
    depsFile = "pkgs/ani-cli/deps.json";
    updater = updateDeps.fetchFromGitHub {
      name = "ani-cli";
      owner = "pystardust";
      repo = "ani-cli";
      rev = "v{version}";
    };
  };

  clear-sans = {
    depsFile = "pkgs/clear-sans/deps.json";
    updater = updateDeps.fetchFromGitHub {
      name = "clear-sans";
      owner = "intel";
      repo = "clear-sans";
      rev = "main";
      version = "1.0";
    };
  };

  dms-plugins = {
    lyrics-on-panel = {
      depsFile = "pkgs/dms-plugins/lyrics-on-panel/deps.json";
      updater = updateDeps.fetchFromGitHub {
        name = "dms-lyrics-on-panel";
        owner = "KangweiZhu";
        repo = "lyrics-on-panel";
        rev = "main";
        version = "unstable";
      };
    };
  };

  minijinja-cli = {
    depsFile = "pkgs/minijinja-cli/deps.json";
    updater = updateDeps.fetchCrateRustPackage {
      name = "minijinja-cli";
      pname = "minijinja-cli";
    };
  };

  rpcs3 = {
    depsFile = "pkgs/rpcs3/deps.json";
    updater = updateDeps.fetchFromGitHub {
      name = "rpcs3-discord-rpc";
      owner = "Vestrel";
      repo = "discord-rpc";
      rev = "master";
      key = "discordRpc";
    };
  };

  ryubing = {
    depsFile = "pkgs/ryubing/deps.json";
    updater = updateDeps.dotnet {
      name = "ryubing";
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
      latestVersion = {
        url = "https://git.ryujinx.app/api/v1/repos/ryubing/ryujinx/tags?limit=100";
        jq = ''[.[].name | select(startswith("Canary-"))][0] | ltrimstr("Canary-")'';
      };
    };
  };

  thorium = {
    depsFile = "pkgs/thorium/deps.json";
    updater = updateDeps.fetchurl {
      name = "thorium-browser";
      version = "144.0.7559.254";
      url = "https://github.com/gz83/thorium/releases/download/M144.0.7559.254/thorium-browser_144.0.7559.254_AVX2.deb";
    };
  };

  vita3k = {
    depsFile = "pkgs/vita3k/deps.json";
    updater = updateDeps.fetchGitHubReleaseAsset {
      name = "vita3k";
      owner = "Vita3K";
      repo = "Vita3K-builds";
      asset = "Vita3K-x86_64.AppImage";
    };
  };

  proton-ge-11-1 = {
    depsFile = "pkgs/proton-ge-11-1/deps.json";
    updater = updateDeps.fetchurl {
      name = "proton-ge-11-1";
      version = "GE-Proton11-1";
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz";
    };
  };
}
