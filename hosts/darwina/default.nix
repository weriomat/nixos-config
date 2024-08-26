# Inspired by https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix
{
  inputs,
  nix-colors,
  prism,
  nix-index-database,
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
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
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
              prism.homeModules.prism # for compatability
              nix-colors.homeManagerModules.default
              mac-app-util.homeManagerModules.default
              nix-index-database.hmModules.nix-index
              inputs.catppuccin.homeManagerModules.catppuccin
            ];
          };
        }
      ];
    }
