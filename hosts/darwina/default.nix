# Inspired by https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix
{
  inputs,
  nix-colors,
  ...
}:
let
  globals = {
    username = "eliasengel";
    laptop = true;
  };
in
with inputs;
# TODO: https://github.com/ivankovnatsky/nixos-config/tree/71f970431793b8bddd7ec9c40681d70fc3cc8a70/modules/darwin
# TODO: https://github.com/ivankovnatsky/nixos-config/blob/71f970431793b8bddd7ec9c40681d70fc3cc8a70/machines/Ivans-Mac-mini/dns.nix
# TODO: https://github.com/ryuheechul/dotfiles/blob/c84b700104a0d3de6c21648f56a938478f8fbd79/nix/darwin/configuration.nix
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit inputs nix-colors globals; };
  modules = [
    ../../system/darwin
    ./ssh.nix
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = { inherit inputs nix-colors globals; };
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          inputs.arkenfox.hmModules.default
        ];
        users.eliasengel.imports = [
          ../../home/darwin
          ../../home/config
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
