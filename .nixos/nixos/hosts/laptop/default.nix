{
  inputs,
  outputs,
  nix-colors,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs outputs nix-colors;};
  modules = [
    ../../modules/nixos/config-laptop.nix
    ./hardware-configuration.nix
    ./hardware-configuration-add.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {inherit inputs outputs nix-colors;};
        useUserPackages = true;
        useGlobalPkgs = true;
        users.marts.imports = [
          ../../modules/home-manager/nixos/home_laptop.nix
          ../../modules/home-manager
          nix-colors.homeManagerModules.default
        ];
      };
    }
  ];
}
