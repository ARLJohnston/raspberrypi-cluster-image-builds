{ pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    ];
    package = pkgs.k3s.overrideAttrs (oldAttrs: { version = "1.31.0+k3s1"; });
  };
}
