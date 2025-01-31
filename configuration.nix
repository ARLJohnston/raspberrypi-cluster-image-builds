{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ git lsof];

  networking.hostName = "pi";
  users = {
    users.pi = {
      password = "password";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvI8WT1wVlTtqheO4pS0zOInO9Da4V3BGeTOlTviCJx" ];
    };
    users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvI8WT1wVlTtqheO4pS0zOInO9Da4V3BGeTOlTviCJx" ];
    users.root.initialHashedPassword = "";
  };
  services.getty.autologinUser = "pi";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  networking = {
    usePredictableInterfaceNames = false; # As the Pi3 only has 1×wlan and 1×eth 'unpredictable' order has no effect

    interfaces."eth0" = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.0.0.20"; # Need to replace during build
        prefixLength = 24;
      }];
      ipv6.addresses = [];
    };
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall.enable = false;

  # Needed kernel parameters for running K3s
  # https://pet2cattle.com/2020/12/k3s-installation-raspberry
  boot.kernelParams = [
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];


  networking.firewall.allowedUDPPorts = [
    8472  # K3s, flannel: required if using multi-node for inter-node networking
  ];
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };
}
