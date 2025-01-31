### On NixOS
If you're running NixOS and want to use this template to build the Raspberry Pi
4 Image, you'll need to emulate an arm64 machine by adding the following to your
NixOS configuration.

```
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
```

### Pi3 builds
Pi3 builds mostly follow [this blog post](https://myme.no/posts/2022-12-01-nixos-on-raspberrypi.html).

Current targets:
| pi3               | base image, boots with ssh |
| pi3_docker_worker | base with docker installed |


To build:
```shell
nix build .#nixosConfigurations.<target>.config.system.build.sdImage
```

### Flashing
```shell
sudo dd if=./result/<image> of=<device> status=progress bs=4M conv=noerror,fsync
```

Alternatively, ensure the image has a supported extension and use [Rasberry Pi Imager](https://github.com/raspberrypi/rpi-imager) to flash
