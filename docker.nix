{ ... }:
{
  virtualisation = {
    containers.enable = true;
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = "ext4";
    };
  };
}
