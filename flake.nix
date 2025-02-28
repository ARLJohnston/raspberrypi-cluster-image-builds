{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };
  outputs = { self, nixpkgs }@inputs: {
    nixosConfigurations = {
      pi3 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            config.system.stateVersion = "25.05";
          }
          ./configuration.nix
        ];
      };

      pi3_docker_worker = self.nixosConfigurations.pi3.extendModules {
        modules = [
          ./docker.nix
        ];
      };

      pi3_docker_supervisor = self.nixosConfigurations.pi3_docker_worker.extendModules {
        modules = [
          ./supervisor.nix
        ];
      };

      pi3_kubernetes_worker = self.nixosConfigurations.pi3_docker_worker.extendModules {
        modules = [
        ./kubernetes.nix
        {
          services.k3s = {
            enable = true;
            role = "agent";
            token = "qR0Z[l,Dt80F$hJ38;Nhgk[!^[]_gb";
            serverAddr = "https://10.0.0.40:6443";
            extraFlags = ["--disable=traefik"];
          };
        }
        ];
      };

      pi3_kubernetes_supervisor = self.nixosConfigurations.pi3_docker_worker.extendModules {
        specialArgs = {inherit inputs;};
        modules = [
          ./supervisor.nix
         ./kubernetes.nix
          {
            services.k3s = {
              enable = true;
              role = "server";
              token = "qR0Z[l,Dt80F$hJ38;Nhgk[!^[]_gb";
              clusterInit = true;
              extraFlags = ["--disable=traefik"];
            };
          }
        ];
      };

      pi3_servicemesh_worker = self.nixosConfigurations.pi3_kubernetes_worker.extendModules {
        modules = [
          ./servicemesh.nix
        ];
      };
      pi3_servicemesh_supervisor =  self.nixosConfigurations.pi3_kubernetes_supervisor.extendModules {
        modules = [
          ./servicemesh.nix
        ];
      };
    };
  };
}
