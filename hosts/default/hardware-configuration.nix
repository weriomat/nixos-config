# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eef07fd7-9b9d-436a-bd0c-ccc19050a396";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-18c6f525-719b-4b5f-bcb2-7e9ba01353d1".device = "/dev/disk/by-uuid/18c6f525-719b-4b5f-bcb2-7e9ba01353d1";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1AD7-2778";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/1631adfb-0d13-4a18-8ee5-ae0697077df4";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
