{...}: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      openASAR.enable = false;
      vencord = {
        enable = true;
      };
      branches = ["stable"];
      commandLineArgs = [
        "--enable-blink-features=MiddleClickAutoscroll"
      ];
    };
    config = {
      autoUpdateNotification = true;
      notifyAboutUpdates = true;
      useQuickCss = true;
      frameless = true;
      enabledThemes = ["dank-discord.css"];
      plugins = {
        autoDndWhilePlaying = {
          enable = true;
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
        shikiCodeblocks = {
          enable = true;
          theme = "https://cdn.jsdelivr.net/gh/shikijs/textmate-grammars-themes@bc5436518111d87ea58eb56d97b3f9bec30e6b83/packages/tm-themes/themes/tokyo-night.json";
          useDevIcon = "COLOR";
        };
        translate = {
          enable = true;
        };
        gifProviderSwitcher = {
          enable = true;
        };
        noMiddleClickPaste = {
          enable = true;
        };
      };
    };
  };
}
