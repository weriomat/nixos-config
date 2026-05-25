{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        mesa
        mesa.opencl
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
        mesa.opencl
      ];
    };
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
      overdrive.enable = true;
    };
  };

  environment = {
    sessionVariables.VDPAU_DRIVER = "radeonsi";
    systemPackages = [ pkgs.clinfo ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 50;
    };

    # TODO: here
    # extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    #  kernelModules = ["acpi_call"];
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks = {
        devices."luks-e21fd631-a002-472c-a43c-bd984147f9a2".device =
          "/dev/disk/by-uuid/e21fd631-a002-472c-a43c-bd984147f9a2";
        devices."luks-18c6f525-719b-4b5f-bcb2-7e9ba01353d1".device =
          "/dev/disk/by-uuid/18c6f525-719b-4b5f-bcb2-7e9ba01353d1";
      };
    };
    kernelModules = [ "kvm-amd" ];

    # support for building nix packages for rp4
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # NOTE: kernel is pinned with support for zfs
    kernelPackages = pkgs.linuxPackages_6_12;
    extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_12.v4l2loopback ];
  };

  fileSystems = {
    # nvme
    "/" = {
      device = "/dev/disk/by-uuid/eef07fd7-9b9d-436a-bd0c-ccc19050a396";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1AD7-2778";
      fsType = "vfat";
    };

    # other

    # external 5tb hdd
    # "/home/${globals.username}/Backup" = {
    #   device = "/dev/disk/by-uuid/1ac218ec-352a-46dd-a20f-548040ebb383";
    #   fsType = "ext4";
    # };
    # "/home/${globals.username}/Backup_3TB" = {
    #   device = "/dev/disk/by-uuid/d65d9c4c-544a-42fa-bc0e-05a7be7d11be";
    #   fsType = "ext4";
    # };
    # "/home/${globals.username}/Backup_1TB" = {
    #   device = "/dev/disk/by-uuid/01342007-77d0-4fe5-8804-f8c8f06a2bd7";
    #   fsType = "ext4";
    # };
    # "/home/${globals.username}/Backup_1TB_SSD" = {
    #   device = "/dev/disk/by-uuid/f839677a-a943-45a6-9cf9-49ae971975e5";
    #   fsType = "ext4";
    # };
    # "/home/${globals.username}/nfs" = {
    #   device = "10.0.0.20:/storage/media";
    #   fsType = "nfs";
    # };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/1631adfb-0d13-4a18-8ee5-ae0697077df4"; } ];
  zramSwap.enable = true;

  # As per https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
