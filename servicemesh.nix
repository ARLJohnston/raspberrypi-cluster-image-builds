{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      linkerd
    ];
}
