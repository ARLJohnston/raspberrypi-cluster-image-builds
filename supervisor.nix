{ ... }:
{
  services.prometheus = {
    enable = true;
    port = 9090;
    configText = builtins.readFile ./prometheus.yml;
    extraFlags = ["--storage.tsdb.retention.time=1y" "--storage.local.path=/"];
  };
}
