{config, ...}: {
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  systemd.services.mullvad-daemon.postStart = ''
    while ! mullvad status >/dev/null 2>&1; do sleep 1; done
    mullvad account login "$(cat ${config.sops.secrets."api/mullvad".path})" || true
    mullvad tunnel set ipv6 on
    mullvad dns set default --block-ads --block-malware
  '';
}
