# Inspired by https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix
{
  inputs,
  nix-colors,
  ...
}:
with inputs;
  nix-darwin.lib.darwinSystem {
    specialArgs = {inherit inputs nix-colors;};
    modules = [
      ../../modules/darwin
      mac-app-util.darwinModules.default
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs nix-colors;};
          useGlobalPkgs = true;
          useUserPackages = true;
          users.eliasengel.imports = [
            ../../modules/home-manager/darwin
            ../../modules/home-manager/common
            nix-colors.homeManagerModules.default
            mac-app-util.homeManagerModules.default
          ];
        };
      }
    ];
  }
