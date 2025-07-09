{
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    gnome-klotski
    cava
    swaybg
  ];

  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
