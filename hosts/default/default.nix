{
  inputs,
  outputs,
  nix-colors,
  prism,
  nix-index-database,
  ...
}: let
  globals = {
    isLaptop =
      false; # global for specifying if hyprland should be enabled
    isWork = false;
    username = "marts";
    host = "desktop";
    hostname = "nixos";
    laptop = false;
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs nix-colors globals;};
    modules = [
      ../../modules/nixos/configuration.nix
      ./hardware-configuration.nix
      ./config.nix
      ./ssh.nix

      # sops
      inputs.sops-nix.nixosModules.sops

      # arkenfox
      inputs.arkenfox.hmModules.default

      inputs.home-manager.nixosModules.home-manager

      {
        home-manager = {
          extraSpecialArgs = {inherit inputs outputs nix-colors globals;};
          useUserPackages = true;
          useGlobalPkgs = true;
          sharedModules = [
            inputs.arkenfox.hmModules.default
          ];
          users.${globals.username}.imports = [
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
