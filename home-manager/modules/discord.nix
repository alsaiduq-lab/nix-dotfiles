{
  pkgs,
  inputs,
  ...
}: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      vencord.unstable = true;
      branch = "stable";
      autoscroll.enable = true;
      # not sure why 130 ships with a broken chromium
      package = inputs.nixcord.packages.${pkgs.system}.discord.overrideAttrs (old: {
        version = "0.0.129";
        src = pkgs.fetchurl {
          url = "https://stable.dl2.discordapp.net/apps/linux/0.0.129/discord-0.0.129.tar.gz";
          hash = "sha256-CscycDRH5N1etiYmjm7wFzL5dFxr7xOX9MkZTHqcFOo=";
        };
      });
    };
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
        reverseImageSearch = {
          enable = true;
        };
        sendTimestamps = {
          enable = true;
        };
        youtubeAdblock = {
          enable = true;
        };
        summaries = {
          enable = true;
        };
        translate = {
          enable = true;
        };
      };
    };
  };
}
