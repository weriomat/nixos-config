{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  # imports = [
  #   <nixpkgs/nixos/modules/profiles/hardened.nix>
  # ];
  options.hardening.enable = mkEnableOption "Enable hardening settings"; # // {
  # default = true;
  # };
  # TODO: integrate into Nixos-Server

  config = mkIf config.hardening.enable {
    # profiles.hardened.enable = true;
    # Inspired by https://github.com/Lassulus/superconfig/blob/32b0c6628fa4af136c635f62e1de9f83419712d0/2configs/hardening.nix
    security.chromiumSuidSandbox.enable = true;
  };

}
