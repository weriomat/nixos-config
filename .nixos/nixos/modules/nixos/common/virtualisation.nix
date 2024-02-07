{pkgs, ...}: {
  users.users.marts.extraGroups = [
    "libvirtd"
    #   # "audio"
    #   # "video"
    #   # "disk"
    #   # "input"
    #   # "kvm"
    #   # "libvirt-qemu"
  ];
  programs.virt-manager.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # https://nixos.wiki/wiki/NixOps/Virtualization
  # https://christitus.com/vm-setup-in-linux/
  environment.systemPackages = with pkgs; [
    # python3Full
    # python.pkgs.pip
    # libverto
    # qemu
    # qemu-utils
    # # qemu-kvm
    # libvirt
    virt-manager
    virt-viewer
    gnome.adwaita-icon-theme
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice

    # unstable.quickemu
    # quickgui
  ];
}
