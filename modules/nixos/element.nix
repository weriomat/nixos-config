{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    getExe
    ;
  cfg = config.services.element-desktop;
in
{
  options.services.element-desktop = {
    enable = mkEnableOption "element desktop";
    package = mkPackageOption pkgs "element-desktop" { };
  };

  config = mkIf cfg.enable {
    services.keyring.enable = true;
    environment = {
      systemPackages = [ cfg.package ];
      sessionVariables.element = "${getExe cfg.package} --password-store='gnome_libsecret'";
    };
  };
}
