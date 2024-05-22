{
  inputs,
  outputs,
  nix-colors,
  prism,
  nix-index-database,
  ...
}: let
  globals = {
    isLaptop = true; # global for specifying if hyprland should be enabled
    isWork = false;
    username = "marts";
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs nix-colors globals;};
    modules = [
      ../../modules/nixos/config-laptop.nix
      ./hardware-configuration.nix
      ./hardware-configuration-add.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs outputs nix-colors globals;};
          useUserPackages = true;
          useGlobalPkgs = true;
          users.${globals.username}.imports = [
            ../../modules/home-manager/nixos
            ../../modules/home-manager
            nix-colors.homeManagerModules.default
            nix-index-database.hmModules.nix-index
            prism.homeModules.prism
          ];
        };
      }
    ];
  }
