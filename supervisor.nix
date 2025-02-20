{ pkgs, ... }:
let
  # Replace IPs using sed-style syntax
  nodeExporterTargets = [
    "10.0.0.21:9002"
    "10.0.0.22:9002"
    "10.0.0.23:9002"
    "10.0.0.20:9002"
  ];
in
{
    environment.systemPackages = with pkgs; [
      prometheus
    ];

  services.prometheus = {
    enable = true;
    port = 9090;


    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };

    scrapeConfigs = [
      # Node Exporter job
      {
        job_name = "node_exporter";
        static_configs = [
          {
            targets = nodeExporterTargets;
          }
        ];
      }

      # Docker job
      {
        job_name = "docker";
        dockerswarm_sd_configs = [
          {
            host = "unix:///var/run/docker.sock";
            role = "nodes";
          }
        ];
        relabel_configs = [
          {
            source_labels = [ "__meta_dockerswarm_node_address" ];
            target_label = "__address__";
            replacement = "$1:9323";
          }
          {
            source_labels = [ "__meta_dockerswarm_node_hostname" ];
            target_label = "instance";
          }
        ];
      }

      # Docker Swarm tasks job
      {
        job_name = "dockerswarm";
        dockerswarm_sd_configs = [
          {
            host = "unix:///var/run/docker.sock";
            role = "tasks";
          }
        ];
        relabel_configs = [
          {
            source_labels = [ "__meta_dockerswarm_task_desired_state" ];
            regex = "running";
            action = "keep";
          }
          {
            source_labels = [ "__meta_dockerswarm_service_label_prometheus_job" ];
            regex = ".+";
            action = "keep";
          }
          {
            source_labels = [ "__meta_dockerswarm_service_label_prometheus_job" ];
            target_label = "job";
          }
        ];
      }
    ];
    # scrapeConfigs = [
    #   {
    #     job_name = "node_exporter";
    #     static_configs = [{
    #       targets = [
    #         "10.0.0.21:9002"
    #         "10.0.0.22:9002"
    #         "10.0.0.23:9002"
    #         "10.0.0.20:9002"
    #       ];
    #     }];
    #   }

    #   {
    #     job_name = "docker";
    #     dockerswarm_sd_configs = [{
    #     }];
    #     static_configs = [{
    #       targets = [
    #         "10.0.0.21:9002"
    #         "10.0.0.22:9002"
    #         "10.0.0.23:9002"
    #         "10.0.0.20:9002"
    #       ];
    #     }];
    #   }
    # ];
    ruleFiles = [ ./rules.yml ];
    extraFlags = ["--storage.tsdb.retention.time=1y"];
  };
}
