define build_image
	# $1 : image name
	# $2 : last 2 chars of ip
	sed -i 's/10\.0\.0\.../10\.0\.0\.$(2)/g' configuration.nix
	sed -i 's/192\.168\.12\.../192\.168\.12\.$(2)/g' configuration.nix
	sed -i 's/host = "pi.."/host = "pi$(2)"/g' configuration.nix
	nix build --cores 4 .#nixosConfigurations.$(1).config.system.build.sdImage
	nix shell nixpkgs#zstd -c unzstd -o $(1)-10-0-0-$(2).img ./result/sd-image/nixos*
	mv *.img ../images/
endef

define set_prometheus_targets
	# $1 Cluster group - 10.0.0.{$1}(0|1|2|3)
	sed -i 's/10\.0\.0\../10\.0\.0\.$(1)/g' prometheus.yml
endef

define set_k8s_server
	# $1 Cluster group - 10.0.0.{$1}(0|1|2|3)
	sed -i 's/10\.0\.0\../10\.0\.0\.$(1)/g' flake.nix
endef

docker-images:
	$(call set_prometheus_targets,2)
	$(call build_image,pi3_docker_supervisor,20)
	$(call build_image,pi3_docker_worker,21)
	$(call build_image,pi3_docker_worker,22)
	$(call build_image,pi3_docker_worker,23)

kubernetes-images:
	$(call set_k8s_server,3)
	$(call set_prometheus_targets,3)
	$(call build_image,pi3_kubernetes_supervisor,30)
	$(call build_image,pi3_kubernetes_worker,31)
	$(call build_image,pi3_kubernetes_worker,32)
	$(call build_image,pi3_kubernetes_worker,33)

servicemesh-images:
	$(call set_k8s_server,4)
	$(call set_prometheus_targets,4)
	$(call build_image,pi3_servicemesh_supervisor,40)
	$(call build_image,pi3_servicemesh_worker,41)
	$(call build_image,pi3_servicemesh_worker,42)
	$(call build_image,pi3_servicemesh_worker,43)

all: docker-images kubernetes-image servicemesh-images
