{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (polybar.override {
      alsaSupport = false;
      curlSupport = true;
      i3Support = true;
      mpdSupport = true;
      pulseSupport = true;
      nlSupport = true;
      iwSupport = true;
    })
  ];
}
