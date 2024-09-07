{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
with lib; {
  options.virt.enable = mkEnableOption "Enable virtualisation";

  config = mkIf config.virt.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
    };
    users.users.${globals.username} = {
      extraGroups = ["libvirtd" "docker"]; # docker new
    };

    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    # Useful otherdevelopment tools
    environment.systemPackages = with pkgs; [
      quickemu

      # new
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      docker-compose # start group of containers for dev
    ];
  };
}
