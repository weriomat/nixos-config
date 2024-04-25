{
  pkgs,
  globals,
  ...
}: {
  # external 5tb hdd
  fileSystems."/home/${globals.username}/Backup" = {
    device = "/dev/disk/by-uuid/1ac218ec-352a-46dd-a20f-548040ebb383";
    fsType = "ext4";
  };

  # followed guide from https://nixos.wiki/wiki/AMD_GPU
  boot = {
    initrd.kernelModules = ["amdgpu"];
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices."luks-e21fd631-a002-472c-a43c-bd984147f9a2".device = "/dev/disk/by-uuid/e21fd631-a002-472c-a43c-bd984147f9a2";

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
