{
  pkgs,
  config,
  ...
}: {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
  services.resolved.enable = true;
  systemd.services."mullvad-daemon".postStart = let
    mullvad = "${config.services.mullvad-vpn.package}/bin/mullvad";
  in ''
    while ! ${mullvad} status >/dev/null 2>&1; do sleep 1; done
    ${mullvad} account login "$(cat ${config.sops.secrets."api/mullvad".path})" || true
    ${mullvad} auto-connect set on
    ${mullvad} tunnel set ipv6 on
    ${mullvad} dns set default --block-ads --block-malware
  '';
}
