{
  pkgs,
  lib,
  config,
  ...
}: {
  options.doc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable documentation settings";
    };
  };
  config = lib.mkIf config.doc.enable {
    documentation = {
      enable = true;
      man.enable = true;
      dev.enable = lib.mkIf pkgs.stdenv.isLinux true;
      doc.enable = true;
      nixos.enable = lib.mkIf pkgs.stdenv.isLinux true;
      info.enable = true;
    };
    services.hoogle.enable =
      lib.mkIf pkgs.stdenv.isLinux
      true; # -> on 127.0.0.1/8080, only works on linux
  };
}
