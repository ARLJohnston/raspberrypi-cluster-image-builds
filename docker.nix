{ ... }:
{
  virtualisation = {
    containers.enable = true;
    docker = {
        enable = true;
        daemon.settings = {metrics-addr = "0.0.0.0:9323"; experimental = true; }; # https://prometheus.io/docs/guides/dockerswarm/
      };
  };
}
