{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.virt.enable = mkEnableOption "Enable virtualisation";

  config = mkIf config.virt.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
    };
    users.users.${globals.username} = {
      extraGroups = [
        "libvirtd"
        "docker"
      ]; # docker new
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
    environment.systemPackages = [
      pkgs.quickemu

      # new
      pkgs.dive # look into docker image layers
      pkgs.podman-tui # status of containers in the terminal
      pkgs.docker-compose # start group of containers for dev
    ];
  };

  # TODO: here
  # environment.systemPackages = [ pkgs.virtiofsd ];
  #   programs.virt-manager.enable = true;
  #   services = {
  #     qemuGuest.enable = true;
  #     spice-vdagentd.enable = true;
  #   };

  #   virtualisation.libvirtd.enable = true;
  # config = mkIf cfg.qemu {
  #   dconf.settings."org/virt-manager/virt-manager/connections" = {
  #     autoconnect = [ "qemu:///system" ];
  #     uris = [ "qemu:///system" ];
  #   };
  # };
}
