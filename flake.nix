{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
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
    };
  };
}
