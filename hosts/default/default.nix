{
  inputs,
  outputs,
  nix-colors,
  ...
}: let
  globals = {
    isLaptop =
      false; # global for specifying if hyprland should be enabled
    username = "marts";
    host = "desktop";
    hostname = "nixos";
    laptop = false;
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs nix-colors globals;};
    modules = [
      ../../system/nixos/configuration.nix
      ../../modules/nixos
      ./hardware-configuration.nix
      ./config.nix
      ./ssh.nix

      # sops
      inputs.sops-nix.nixosModules.sops

      # arkenfox
      inputs.arkenfox.hmModules.default

      # catppuccin nix
      inputs.catppuccin.nixosModules.catppuccin

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
            ../../home/nixos
            ../../modules/home-manager
            ../../home/config # TODO: here
            inputs.nix-colors.homeManagerModules.default
            inputs.nix-index-database.hmModules.nix-index
            inputs.catppuccin.homeManagerModules.catppuccin
          ];
        };
      }
    ];
  }
