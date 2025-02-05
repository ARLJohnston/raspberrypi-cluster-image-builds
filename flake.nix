{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-snapd ={
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, nix-snapd }@inputs: {
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
          nix-snapd.nixosModules.default
          {
            services.snap.enable = true;
          }
        ];
      };

      pi3_kubernetes_supervisor = self.nixosConfigurations.pi3_kubernetes_worker.extendModules {
        specialArgs = {inherit inputs;};
        modules = [
          ./supervisor.nix
        ];
      };

      pi3_istio_worker = self.nixosConfigurations.pi3_kubernetes_worker;
      pi3_istio_supervisor =  self.nixosConfigurations.pi3_kubernetes_supervisor;
    };
  };
}
