define build_image
	# $1 : image name
	# $2 : last 2 chars of ip
	sed -i 's/10\.0\.0\.../10\.0\.0\.$(2)/g' configuration.nix
	nix build .#nixosConfigurations.$(1).config.system.build.sdImage
	nix shell nixpkgs#zstd -c unzstd -o $(1)-10-0-0-$(2).img ./result/sd-image/nixos-sd-image-25.05.*
	mv *.img ../images/
endef

docker-images:
	$(call build_image,pi3_docker_supervisor,20)
	$(call build_image,pi3_docker_worker,21)
	$(call build_image,pi3_docker_worker,22)
	$(call build_image,pi3_docker_worker,23)
