{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.services.keyring;
in
{
  options.services.keyring.enable = mkEnableOption "gnome keyring settings";

  config = mkIf cfg.enable {
    # unlock keyring upon right entry of password on boot
    security.pam.services.greetd.enableGnomeKeyring = true;

    # greetd-password.enableGnomeKeyring = true;
    # login.enableGnomeKeyring = true;

    # To store the token for auth
    services.gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };

    # viewer of secrets
    programs.seahorse.enable = true;
  };
}
