{
  pkgs,
  globals,
  ...
}: {
  # external 5tb hdd
  fileSystems = {
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
  };

  # followed guide from https://nixos.wiki/wiki/AMD_GPU
  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 100;
    };
    initrd = {
      kernelModules = ["amdgpu"];
      luks.devices."luks-e21fd631-a002-472c-a43c-bd984147f9a2".device = "/dev/disk/by-uuid/e21fd631-a002-472c-a43c-bd984147f9a2";
    };

    # support for building nix packages for rp4
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

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
  # environment.sessionVariables.VDPAU_DRIVER = "radeonsi";
  services.xserver.videoDrivers = ["amdgpu"];
}
