{
  inputs,
  settings,
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
    "github_token"
    "git-credentials"
    "api/mullvad"
    "forgejo-cred"
    "anubis"
    "api/hf"
  ];
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    useSystemdActivation = true;
    age = {
      keyFile = "/home/${settings.user}/.config/sops/age/keys.txt";
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];
    secrets = lib.genAttrs secrets (_: {owner = "${settings.user}";});
  };
}
