{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ssh;
in
{
  options.ssh.enable = mkEnableOption "setup for ssh pinentry/ ssh daemon/ smartscard" // {
    default = true;
  };

  config = mkIf cfg.enable {
    services = {
      openssh.enable = false;
      udev.packages = [ pkgs.yubikey-personalization ];
      pcscd.enable = true;
    };

    programs.ssh = {
      enableAskPassword = true;
      askPassword = pkgs.pinentry-gtk2 + "/bin/pinentry";
      startAgent = false;
    };
  };
}
