{
  inputs,
  outputs,
  nix-colors,
  prism,
  nix-index-database,
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

      ./ssh.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs outputs nix-colors globals;};
          useUserPackages = true;
          useGlobalPkgs = true;
          users.marts.imports = [
            ../../modules/home-manager/nixos
            ../../modules/home-manager
            prism.homeModules.prism
            nix-colors.homeManagerModules.default

            nix-index-database.hmModules.nix-index
          ];
        };
      }
    ];
  }
