{ ... }:
{
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.arljohnston";
      port = 2342;
      addr = "127.0.0.1";
      };
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    configText = builtins.readFile ./prometheus.yml;
    extraFlags = ["--storage.tsdb.retention.time=1y"];
  };
}
