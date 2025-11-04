{
  pkgs,
  ...
}:
{
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

  environment.systemPackages = [
    pkgs.paperkey
    pkgs.yubioath-flutter
  ];

}
