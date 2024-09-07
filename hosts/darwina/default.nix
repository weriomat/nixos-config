# Inspired by https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix
{
  inputs,
  nix-colors,
  ...
}: let
  globals = {
    isWork = false;
    username = "eliasengel";
    architekture = "aarch64-darwin";
    laptop = true;
  };
in
  with inputs;
    nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs nix-colors globals;};
      modules = [
        ../../modules/darwin
        ./ssh.nix
        inputs.mac-app-util.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {inherit inputs nix-colors globals;};
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              inputs.arkenfox.hmModules.default
            ];
            users.eliasengel.imports = [
              ../../modules/home-manager/darwin
              ../../modules/home-manager
              inputs.nix-colors.homeManagerModules.default
              inputs.mac-app-util.homeManagerModules.default
              inputs.nix-index-database.hmModules.nix-index
              inputs.catppuccin.homeManagerModules.catppuccin
            ];
          };
        }
      ];
    }
