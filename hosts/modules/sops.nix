{
  inputs,
  config,
  lib,
  ...
}: let
  apiKeys = [
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
    "cachix/token"
  ];
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets =
      lib.genAttrs apiKeys (_: {owner = "cobray";})
      // {
        "cachix/token" = {};
        "git/credentials" = {
          owner = "cobray";
          mode = "0600";
        };
      };
  };
}
