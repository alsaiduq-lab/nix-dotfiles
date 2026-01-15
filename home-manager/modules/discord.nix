{
  pkgs,
  config,
  ...
}: {
  programs.nixcord = {
    enable = true;
    discord.enable = true;
    equibop.enable = true;
    config = {
      autoUpdateNotification = true;
      notifyAboutUpdates = true;

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
        RPCEditor = {
          enable = true;
        };
        ReviewDB = {
          enable = true;
        };
        anonymiseFileNames = {
          enable = true;
          consistent = "killallWumpus";
        };
        autoZipper = {
          enable = true;
        };
        betterInvites = {
          enable = true;
        };
        biggerStreamPreview = {
          enable = true;
        };
        blockKeywords = {
          enable = true;
          useRegex = true;
          caseSensitive = true;
          blockedWords = "Wumpus";
        };
        customIdle = {
          enable = true;
        };
        expressionCloner = {
          enable = true;
        };
        fixFileExtensions = {
          enable = true;
        };
        fixYoutubeEmbeds = {
          enable = true;
        };
        forceOwnerCrown = {
          enable = true;
        };
        reverseImageSearch = {
          enable = true;
        };
        richMagnetLinks = {
          enable = true;
        };
        sekaiStickers = {
          enable = true;
        };
        sendTimestamps = {
          enable = true;
        };
      };
    };
  };
}
