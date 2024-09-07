{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.doc.enable = mkEnableOption "Enable documentation settings";

  config = mkIf config.doc.enable {
    documentation = {
      enable = true;
      man = {
        enable = true;
        man-db.enable = true;
        generateCaches = true;
      };
      dev.enable = lib.mkIf pkgs.stdenv.isLinux true;
      doc.enable = true;
      nixos.enable = lib.mkIf pkgs.stdenv.isLinux true;
      info.enable = true;
    };
  };
}
