{
  inputs,
  outputs,
  nix-colors,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs outputs nix-colors;};
  modules = [
    ../../modules/nixos/configuration.nix
    ./hardware-configuration.nix
    ./hardware-config-add.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {inherit inputs outputs nix-colors;};
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
