{
  inputs,
  config,
  lib,
  ...
}: let
  secrets = [
    "api/openai"
    "api/deepseek"
    "api/anthropic"
    "api/openrouter"
    "api/xai"
    "api/perplexity"
    "api/replicate"
    "api/brave"
    "api/firecrawl"
    "api/deepl"
    "api/gelbooru_id"
    "api/gelbooru_api"
    "api/fireworks"
    "api/cachix"
    "api/vast"
    "api/hf"
    "git-credentials"
  ];
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = lib.genAttrs secrets (_: {owner = "${config.theme.user}";});
  };
}
