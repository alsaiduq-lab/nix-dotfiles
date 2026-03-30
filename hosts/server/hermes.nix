{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.hermes-agent = {
    enable = true;
    settings = {
      model.default = "google/gemini-2.5-flash-lite";
      model.provider = "openrouter";
      terminal.backend = "local";
      agent.max_turns = 60;
      memory.memory_enabled = true;
      toolsets = ["all"];
      compression = {
        enabled = true;
        summary_model = "arcee-ai/trinity-large-preview:free";
      };
      api_server = {
        enabled = true;
        port = 8642;
        host = "127.0.0.1";
      };
    };
    documents = {
      "AGENTS.md" = builtins.readFile "${inputs.soul}/AGENTS.md";
      "SOUL.md" = builtins.readFile "${inputs.soul}/SOUL.md";
    };
    mcpServers = {
      searxng = {
        command = "npx";
        args = ["-y" "mcp-searxng"];
        env = {
          SEARXNG_URL = "http://localhost:11212";
        };
      };
      wolfram-alpha = {
        command = "uvx";
        args = ["MCP-wolfram-alpha"];
      };
    };
    extraPackages = with pkgs; [jq ripgrep curl git];
  };

  systemd.services.hermes-agent.serviceConfig.ExecStartPre = let
    script = pkgs.writeShellScript "hermes-env-setup" ''
            set -euo pipefail
            ENV_FILE="/var/lib/hermes/.hermes/.env"
            install -o hermes -g hermes -m 0600 /dev/null "$ENV_FILE"
            cat > "$ENV_FILE" <<EOF
      OPENROUTER_API_KEY=$(cat ${config.sops.secrets."api/openrouter".path})
      ANTHROPIC_API_KEY=$(cat ${config.sops.secrets."api/anthropic".path})
      OPENAI_API_KEY=$(cat ${config.sops.secrets."api/openai".path})
      DEEPSEEK_API_KEY=$(cat ${config.sops.secrets."api/deepseek".path})
      XAI_API_KEY=$(cat ${config.sops.secrets."api/xai".path})
      FIRECRAWL_API_KEY=$(cat ${config.sops.secrets."api/firecrawl".path})
      DISCORD_BOT_TOKEN=$(cat ${config.sops.secrets."api/discord".path})
      DISCORD_ALLOWED_USERS=$(cat ${config.sops.secrets."discord".path})
      API_SERVER_KEY=$(cat ${config.sops.secrets."api/api-server".path})
      WOLFRAM_API_KEY=$(cat ${config.sops.secrets."api/wolfram".path})
      EOF
            chown hermes:hermes "$ENV_FILE"
    '';
  in "+${script}";

  sops.secrets."api/openrouter".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/anthropic".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/openai".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/deepseek".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/xai".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/firecrawl".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/discord".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/wolfram".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."api/api-server".sopsFile = ../../secrets/secrets.yaml;
  sops.secrets."discord".sopsFile = ../../secrets/secrets.yaml;

  security.sudo.extraRules = [
    {
      users = ["hermes"];
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl status *";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.systemd}/bin/journalctl *";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.coreutils}/bin/df *";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.procps}/bin/free *";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
