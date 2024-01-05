{pkgs, ...}: {
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-824a4395-6dd1-47a2-bed7-5bc5ce2289c3".device = "/dev/disk/by-uuid/824a4395-6dd1-47a2-bed7-5bc5ce2289c3";
}
