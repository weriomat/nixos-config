# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  pkgs,
  globals,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # followed guide from https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

  # TODO: here
  # hardware.graphics = {
  #   enable = true;

  #   extraPackages = with pkgs; [
  #     libva
  #     vaapiVdpau
  #     libvdpau-va-gl
  #   ];
  #   extraPackages32 = with pkgs.pkgsi686Linux; [
  #     vaapiVdpau
  #     libvdpau-va-gl
  #   ];
  #enableAllFirmware = true;
  # };

  # GPU Support - See https://nixos.wiki/wiki/AMD_GPU
  hardware.opengl = {
    enable = true;

    # Support for opencl, vulkan, amdgpu and rocm
    driSupport = true;
    # For 32 bit applications
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
      #   rocm-opencl-icd
      #   rocm-opencl-runtime
      vaapiVdpau
      mesa.drivers
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      amdvlk
      mesa.drivers
      vaapiVdpau
    ];
  };

  environment.sessionVariables.VDPAU_DRIVER = "radeonsi";
  services.xserver.videoDrivers = ["amdgpu"];

  boot = {
    # TODO: here
    # extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    #  kernelModules = ["acpi_call"];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
      luks = {
        devices."luks-e21fd631-a002-472c-a43c-bd984147f9a2".device = "/dev/disk/by-uuid/e21fd631-a002-472c-a43c-bd984147f9a2";
        devices."luks-18c6f525-719b-4b5f-bcb2-7e9ba01353d1".device = "/dev/disk/by-uuid/18c6f525-719b-4b5f-bcb2-7e9ba01353d1";
      };
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 50;
    };

    # support for building nix packages for rp4
    binfmt.emulatedSystems = ["aarch64-linux"];
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
    "/home/${globals.username}/Backup" = {
      device = "/dev/disk/by-uuid/1ac218ec-352a-46dd-a20f-548040ebb383";
      fsType = "ext4";
    };
    "/home/${globals.username}/Backup_3TB" = {
      device = "/dev/disk/by-uuid/d65d9c4c-544a-42fa-bc0e-05a7be7d11be";
      fsType = "ext4";
    };
    "/home/${globals.username}/Backup_1TB" = {
      device = "/dev/disk/by-uuid/01342007-77d0-4fe5-8804-f8c8f06a2bd7";
      fsType = "ext4";
    };
    "/home/${globals.username}/Backup_1TB_SSD" = {
      device = "/dev/disk/by-uuid/f839677a-a943-45a6-9cf9-49ae971975e5";
      fsType = "ext4";
    };
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
