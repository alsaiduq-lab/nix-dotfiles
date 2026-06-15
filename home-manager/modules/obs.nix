{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-shaderfilter
      obs-websocket
      obs-tuna
      input-overlay
      obs-move-transition
      obs-source-record
    ];
  };
}
