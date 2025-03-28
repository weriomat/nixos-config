{
  pkgs,
  lib,
  ...
}:
{
  services = {
    openssh.enable = false;
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  programs.ssh.startAgent = false;

  environment.systemPackages = [
    pkgs.paperkey
    pkgs.yubikey-manager-qt
  ];

}
