{
  pkgs,
  lib,
  config,
  globals,
  ...
}: {
  options.virt = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable virtualisation";
    };
  };
  config = lib.mkIf config.virt.enable {
    environment.systemPackages = with pkgs; [quickemu];
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
    };
    users.users.${globals.username} = {
      extraGroups = ["libvirtd"];
    };
  };
}
