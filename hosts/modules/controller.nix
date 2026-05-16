{pkgs, ...}: {
  hardware.uinput.enable = true;
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0df2", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*054C:0DF2*", MODE="0660", TAG+="uaccess"
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
  '';

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
