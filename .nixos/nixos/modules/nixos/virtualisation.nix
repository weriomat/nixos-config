{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [ libverto qemu virt-manager ];
}
