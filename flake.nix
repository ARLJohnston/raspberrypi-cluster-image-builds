{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
  outputs = { self, nixpkgs, nixos-hardware }: {
    images = {
      pi4_worker = self.nixosConfigurations.pi4_worker.config.system.build.image;
      pi4_supervisor = self.nixosConfigurations.pi4_supervisor.config.system.build.image;
    };


    nixosConfigurations = {
      pi4_worker = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./configuration.nix
        ];
 	 	};

      pi4_supervisor = self.nixosConfigurations.pi4_worker.extendModules {
				modules = [
			    ./supervisor.nix
				];
      };

      docker_worker = self.nixosConfigurations.pi4_worker.extendModules {
				modules = [
			    ./docker.nix
				];
      };

      docker_supervisor = self.nixosConfigurations.pi4_supervisor.extendModules {
				modules = [
			    ./docker.nix
				];
      };

      kubernetes_worker = self.nixosConfigurations.pi4_worker.extendModules {
				modules = [
			    ./kubernetes_worker.nix
				];
      };

      kubernetes_supervisor = self.nixosConfigurations.pi4_supervisor.extendModules {
				modules = [
			    ./kubernetes_supervisor.nix
				];
      };
    };
  };
}
