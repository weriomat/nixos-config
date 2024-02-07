{ inputs, outputs, ... }: {
  inputs.nixpkgs.lib.nixosSystem = {
    system = "x86_64-linux";
    # specialArgs = { inherit inputs outputs; };
    specialArgs = { };
    modules = [
      # ./modules/nixos/common/nix.nix
      ../modules/nixos/configuration.nix
      # ./hosts/desktop/hardware-configuration.nix
      # ./hosts/desktop/hardware-config-add.nix
      ./hardware-configuration.nix
      ./hardware-config-add.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs outputs; };
          useUserPackages = true;
          useGlobalPkgs = true;
          users = { "marts" = import ./modules/home-manager/home.nix; };
        };
      }
    ];
  };
}
