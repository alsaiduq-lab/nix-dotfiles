{pkgs, ...}: {
  # stops the dualsense controller from hijacking audio
  services.pipewire.wireplumber.extraConfig."51-dualsense-audio" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {"device.name" = "~alsa_card\\.usb-Sony_Interactive_Entertainment_DualSense.*";}
        ];
        actions."update-props"."device.disabled" = true;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    dualsensectl
  ];
}
