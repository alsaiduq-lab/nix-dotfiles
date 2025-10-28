{
  config,
  pkgs,
  ...
}: {
  services.redis.servers."" = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
    settings = {
      maxmemory = "256mb";
      maxmemory-policy = "allkeys-lru";
    };
  };
}
