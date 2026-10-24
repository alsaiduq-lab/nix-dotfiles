{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {cudaSupport = true;};

    settings = {
      color_theme = "tokyonight_storm";
      theme_background = false;
      truecolor = true;
      rounded_corners = true;
      vim_keys = true;
      shown_boxes = "cpu mem net proc gpu0";

      graph_symbol = "braille";
      graph_symbol_cpu = "braille";
      graph_symbol_mem = "braille";
      graph_symbol_net = "braille";
      graph_symbol_proc = "braille";
      graph_symbol_gpu = "braille";

      show_gpu_info = "Auto";
      nvml_measure_pcie_speeds = true;
      gpu_mirror_graph = true;
      proc_tree = true;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      cpu_single_graph = false;
      mem_graphs = true;
      show_swap = true;
      net_auto = true;
      net_sync = true;
    };
  };
}
