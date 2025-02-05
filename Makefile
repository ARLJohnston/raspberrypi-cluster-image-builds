define build_image
	# $1 : image name
	# $2 : last 2 chars of ip
	sed -i 's/10\.0\.0\.../10\.0\.0\.$(2)/g' configuration.nix
	sed -i 's/host = "pi.."/host = "pi$(2)"/g' configuration.nix
	nix build --cores 4 .#nixosConfigurations.$(1).config.system.build.sdImage
	nix shell nixpkgs#zstd -c unzstd -o $(1)-10-0-0-$(2).img ./result/sd-image/nixos*
	mv *.img ../images/
endef

docker-images:
	$(call build_image,pi3_docker_supervisor,20)
	$(call build_image,pi3_docker_worker,21)
	$(call build_image,pi3_docker_worker,22)
	$(call build_image,pi3_docker_worker,23)

kubernetes-images:
	$(call  build_image,pi3_kubernetes_supervisor,30)
	$(call  build_image,pi3_kubernetes_worker,31)
	$(call  build_image,pi3_kubernetes_worker,32)
	$(call  build_image,pi3_kubernetes_worker,33)

istio-images:
	$(call build_image,pi3_istio_supervisor,40)
	$(call build_image,pi3_istio_worker,41)
	$(call build_image,pi3_istio_worker,42)
	$(call build_image,pi3_istio_worker,43)
