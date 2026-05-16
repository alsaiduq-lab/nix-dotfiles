{tokyo-night, ...}: {
  programs.nixcord = {
    enable = true;
    quickCss = builtins.readFile "${tokyo-night}/extras/discord/tokyonight_storm.css";
    discord = {
      enable = true;
      openASAR.enable = false;
      vencord.enable = true;
      branch = "stable";
      autoscroll.enable = true;
    };
    config = {
      autoUpdateNotification = true;
      notifyAboutUpdates = true;
      useQuickCss = true;
      frameless = true;
      plugins = {
        AutoDNDWhilePlaying = {
          enable = true;
          excludeInvisible = true;
        };
        BlurNSFW = {
          enable = true;
        };
        ClearURLs = {
          enable = true;
        };
        OnePingPerDM = {
          enable = true;
          allowMentions = true;
          ignoreUsers = "Wumpus"; # die
        };
        ReviewDB = {
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
