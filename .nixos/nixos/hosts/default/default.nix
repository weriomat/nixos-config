{
  inputs,
  outputs,
  nix-colors,
  ...
}: let
  globals.isLaptop =
    false; # global for specifying if hyprland should be enabled
in
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs nix-colors;};
    modules = [
      ../../modules/nixos/configuration.nix
      ./hardware-configuration.nix
      ./hardware-config-add.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs outputs nix-colors globals;};
          useUserPackages = true;
          useGlobalPkgs = true;
          users.marts.imports = [
            ../../modules/home-manager/nixos
            ../../modules/home-manager
            nix-colors.homeManagerModules.default
          ];
        };
      }
    ];
  }
