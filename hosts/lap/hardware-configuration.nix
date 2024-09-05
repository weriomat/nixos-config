# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 100;
    };
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod"];
      kernelModules = [
        "amdgpu"
        "cpufreq_ondemand"
        "cpufreq_powersave"
      ];

      luks = {
        devices."luks-rpool-nvme-Samsung_SSD_990_PRO_2TB_S7DNNU0X417249D-part2".device = "/dev/disk/by-uuid/47848e3e-66c6-43e6-a878-096b608c098d";
        devices."swapDevice".device = "/dev/disk/by-uuid/de8dd340-6c95-471a-9394-db5bef325386";
      };
    };
    kernelModules = ["kvm-amd"];

    extraModulePackages = [];

    # support for building nix packages for rp4
    binfmt.emulatedSystems = ["aarch64-linux"];

    # newer kernel cuz wlan driver crashes cuz of aspm
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
  };

  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/var";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9152-FBB4";
      fsType = "vfat";
    };
  };

  # GPU Support - See https://nixos.wiki/wiki/AMD_GPU
  hardware.opengl = {
    enable = true;

    # Support for opencl, vulkan, amdgpu and rocm
    driSupport = true;
    # For 32 bit applications
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      vaapiVdpau
      mesa.drivers
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      vaapiVdpau
      mesa.drivers
    ];
  };
  environment.sessionVariables.VDPAU_DRIVER = "radeonsi";
  services.xserver.videoDrivers = ["amdgpu"];

  swapDevices = [
    {device = "/dev/disk/by-uuid/a1e33eb4-590f-4a58-8d01-97297fa740f8";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
