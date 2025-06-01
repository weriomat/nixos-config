{
  inputs,
  outputs,
  # globals,
  config,
  ...
}:
let
  globals = import ./globals.nix { } // {
    systemd = config.systemd.package;
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit
            inputs
            outputs
            globals
            ;
        };
        useUserPackages = true;
        useGlobalPkgs = true;
        sharedModules = [ inputs.arkenfox.hmModules.default ];
        users.${globals.username} = {
          imports = [
            ./config-home.nix
            ../../modules/home-manager
            ../../home/nixos
            inputs.nix-index-database.hmModules.nix-index
            inputs.catppuccin.homeModules.catppuccin
          ];
        };
      };
    }
  ];
}
