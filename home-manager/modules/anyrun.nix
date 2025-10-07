{
  config,
  pkgs,
  ...
}: {
  programs.anyrun = {
    enable = true;

    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {absolute = 600;};
      height = {absolute = 0;};

      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = 8;

      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libdictionary.so"
        "${pkgs.anyrun}/lib/libkidex.so"
        "${pkgs.anyrun}/lib/librandr.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/libstdin.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
        "${pkgs.anyrun}/lib/libtranslate.so"
        "${pkgs.anyrun}/lib/libwebsearch.so"
      ];
    };

    extraCss = ''
      * {
        all: unset;
        font-family: "Clear Sans", monospace;
        font-size: 12px;
      }

      #window {
        background: transparent;
      }

      #main {
        background-color: rgba(30, 32, 48, 0.95);
        border: 2px solid #82aaff;
        border-radius: 16px;
        padding: 8px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
      }

      #entry {
        background-color: transparent;
        color: #c8d3f5;
        padding: 12px 16px;
        border-radius: 8px;
        margin: 4px 0;
        transition: all 0.2s ease;
      }

      #entry:selected {
        background-color: #2f334d;
        border-left: 3px solid #82aaff;
      }

      #entry:hover {
        background-color: rgba(47, 51, 77, 0.5);
      }

      #entry #match {
        color: #c8d3f5;
        padding: 4px;
      }

      #entry #match:selected {
        color: #82aaff;
        font-weight: bold;
      }

      box#main entry {
        color: #828bb8;
      }

      box#main entry:selected {
        color: #86e1fc;
      }

      #plugin {
        color: #86e1fc;
        font-weight: bold;
        padding: 8px 16px;
        margin-top: 4px;
        border-top: 1px solid rgba(130, 170, 255, 0.3);
      }

      #match-desc {
        color: #828bb8;
        font-size: 12px;
        opacity: 0.8;
      }

      list#main {
        padding: 8px;
      }

      scrollbar {
        background-color: transparent;
      }

      scrollbar slider {
        background-color: #2f334d;
        border-radius: 8px;
        min-width: 6px;
      }

      scrollbar slider:hover {
        background-color: #82aaff;
      }

      image {
        margin-right: 8px;
        opacity: 0.9;
      }
    '';

    extraConfigFiles = {
      "websearch.ron".text = ''
        Config(
          prefix: "?",
          engines: [Custom]
        )
        Custom(
          name: "searxng",
          url: "127.0.0.1:11212",
        )
      '';

      "dictionary.ron".text = ''
        Config(
          prefix: "D ",
          max_entries: 5,
        )
      '';

      "translate.ron".text = ''
        Config(
          prefix: "T ",
          language_delimiter: ">",
          max_entries: 5,
        )
      '';

      "symbols.ron".text = ''
        Config(
          prefix: "S ",
          symbols: {
            "alpha": "α",
            "beta": "β",
            "gamma": "γ",
            "delta": "δ",
            "epsilon": "ε",
            "lambda": "λ",
            "mu": "μ",
            "pi": "π",
            "sigma": "σ",
            "omega": "ω",
            "check": "✓",
            "cross": "✗",
            "star": "★",
            "heart": "♥",
            "shrug": "¯\\_(ツ)_/¯",
            "jhha": "は",
            "jhhe": "へ",
            "jhwo": "を",
            "jhn": "ん",
            "jhka": "か",
            "jhki": "き",
            "jhku": "く",
            "jhke": "け",
            "jhko": "こ",
            "jhsa": "さ",
            "jhshi": "し",
            "jhsu": "す",
            "jhse": "せ",
            "jhso": "そ",
            "jhta": "た",
            "jhchi": "ち",
            "jhtsu": "つ",
            "jhte": "て",
            "jhto": "と",
            "jhna": "な",
            "jhni": "に",
            "jhnu": "ぬ",
            "jhne": "ね",
            "jhno": "の",
            "jhma": "ま",
            "jhmi": "み",
            "jhmu": "む",
            "jhme": "め",
            "jhmo": "も",
            "jhya": "や",
            "jhyu": "ゆ",
            "jhyo": "よ",
            "jhra": "ら",
            "jhri": "り",
            "jhru": "る",
            "jhre": "れ",
            "jhro": "ろ",
            "jhwa": "わ",
            "jkha": "ハ",
            "jkhe": "ヘ",
            "jkwo": "ヲ",
            "jkn": "ン",
            "jkka": "カ",
            "jkki": "キ",
            "jkku": "ク",
            "jkku": "ケ",
            "jkko": "コ",
            "jksa": "サ",
            "jkshi": "シ",
            "jksu": "ス",
            "jkse": "セ",
            "jkso": "ソ",
            "jkta": "タ",
            "jkchi": "チ",
            "jktsu": "ツ",
            "jkte": "テ",
            "jkto": "ト",
            "ichiK": "一",
            "niK": "二",
            "sanK": "三",
            "yonK": "四",
            "goK": "五",
            "rokuK": "六",
            "nanaK": "七",
            "hachi": "八",
            "kyuu": "九",
            "jyuu": "十",
            "hyaku": "百",
            "senK": "千",
            "manK": "万",
            "j~": "〜",
            "j,": "、",
            "j.": "。",
          },
          max_entries: 5,
        )
      '';

      "shell.ron".text = ''
        Config(
          prefix: "SH ",
          shell: Some("${config.theme.Shell}"),
        )
      '';

      "randr.ron".text = ''
        Config(
          prefix: ":randr",
          max_entries: 5,
        )
      '';

      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 10,
          terminal: Some("${config.theme.Terminal}"),
        )
      '';
      # cant get this to work for some reason
      #"nix-run.ron".text = ''
      #  Config(
      #    prefix: ":nr",
      #    allow_unfree: true,
      #    channel: "nixpkgs-unstable",
      #    max_entries: 5,
      #  )
      #'';
    };
  };
}
