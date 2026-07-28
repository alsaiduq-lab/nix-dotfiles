{
  inputs,
  pkgs,
  ...
}: {
  programs.nixcord = {
    enable = true;
    quickCss = builtins.readFile "${inputs.tokyo-night}/extras/discord/tokyonight_storm.css";
    discord = {
      enable = true;
      openASAR.enable = false;
      vencord = {
        enable = true;
        package = pkgs.vencord;
      };
      branch = "stable";
      commandLineArgs = [
        "--enable-blink-features=MiddleClickAutoscroll"
        "--render-node-override=/dev/dri/renderD128"
      ];
    };
    config = {
      autoUpdateNotification = true;
      notifyAboutUpdates = true;
      useQuickCss = true;
      frameless = true;
      plugins = {
        autoDndWhilePlaying = {
          enable = true;
          # excludeInvisible = true;
        };
        blurNsfw = {
          enable = true;
        };
        clearUrls = {
          enable = true;
        };
        onePingPerDm = {
          enable = true;
          allowMentions = true;
          ignoreUsers = "Wumpus"; # die
        };
        reviewDb = {
          enable = true;
        };
        anonymiseFileNames = {
          enable = true;
        };
        biggerStreamPreview = {
          enable = true;
        };
        customIdle = {
          enable = true;
        };
        fixYoutubeEmbeds = {
          enable = true;
        };
        forceOwnerCrown = {
          enable = true;
        };
        # keeps warning about using oneko, but using cursorBuddy errors out
        oneko = {
          enable = true;
        };
        petpet = {
          enable = true;
        };
        reverseImageSearch = {
          enable = true;
        };
        youtubeAdblock = {
          enable = true;
        };
        summaries = {
          enable = true;
        };
        shikiCodeblocks = {
          enable = true;
          theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/bc5436518111d87ea58eb56d97b3f9bec30e6b83/packages/tm-themes/themes/tokyo-night.json";
          useDevIcon = "COLOR";
        };
        translate = {
          enable = true;
        };
      };
    };
  };
}
