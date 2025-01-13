{ pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";
    extraFlags = toString [
      # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    ];

    serverAddr = "https://10.0.0.10:6443";
    token = "undefined";

    package = pkgs.k3s.overrideAttrs (oldAttrs: { version = "1.31.0+k3s1"; });
  };
}
