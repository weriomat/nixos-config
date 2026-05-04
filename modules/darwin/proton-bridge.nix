{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    getExe
    optionalString
    ;
  cfg = config.services.protonmail-bridge;
in
{
  # launchctl print gui/501/org.nixos.protonmail-bridge launchctl load ~/Library/LaunchAgents/org.nixos.protonmail-bridge.plist
  # SETUP: start via cli, updates disable, telemetry disable
  options.services.protonmail-bridge = {
    enable = mkEnableOption "Protonmail Bridge";
    package = mkOption {
      type = types.package;
      default = pkgs.protonmail-bridge;
      defaultText = "pkgs.protonmail-bridge";
      description = "Protonmail-bridge derivation to use.";
    };
    path = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "with pkgs; [ pass gnome-keyring ]";
      description = "List of derivations to put in protonmail-bridge's path.";
    };

    logDir = lib.mkOption {
      type = types.str;
      description = "Base path for the log dir for stderr/stdout";
    };

    logLevel = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "panic"
          "fatal"
          "error"
          "warn"
          "info"
          "debug"
        ]
      );
      default = null;
      description = "Log level of the Proton Mail Bridge service. If set to null then the service uses it's default log level.";
    };
  };
  config = mkIf cfg.enable {
    launchd.user.agents.protonmail-bridge = {
      path = [
        cfg.package
        "/usr/bin"
      ];
      command =
        "${getExe pkgs.protonmail-bridge} --noninteractive"
        + optionalString (cfg.logLevel != null) " --log-level ${cfg.logLevel}";

      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardErrorPath =
          cfg.logDir + "/Library/Application Support/protonmail/bridge-v3/logs/protonmail-bridge.log";
        StandardOutPath =
          cfg.logDir + "/Library/Application Support/protonmail/bridge-v3/logs/protonmail-bridge.log";
      };

      managedBy = "services.protonmail-bridge.enable";
    };
  };
}
