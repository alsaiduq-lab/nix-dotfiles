{...}: {
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = false;
      configurationLimit = 5;
    };
    kernelModules = ["tcp_bbr"];
    blacklistedKernelModules = ["esp4" "esp6" "rxrpc" "nlmon" "act_pedit" "ksmbd"];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };
  };
}
