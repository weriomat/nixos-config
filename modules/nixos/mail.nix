{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.mail;
in {
  # TODO: when 24.11 lands just enable the thing from there
  options.mail.enable = mkEnableOption "Enable Protonmail Bridge";
  config = mkIf cfg.enable {
    systemd.user.services.protonmail-bridge = {
      description = "Start protonmail-bridge at startup";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Restart = "always";
        ExecStart = "${getExe pkgs.protonmail-bridge} -n";
      };
      path = [pkgs.pass-wayland];
    };
  };
}
