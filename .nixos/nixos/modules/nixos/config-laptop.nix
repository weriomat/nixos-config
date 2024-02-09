{...}: {
  imports = [./common ./user ./gnome];
  audio.enable = true;
  doc.enable = true;
  graphical.enable = true;
  keyboard.enable = true;
  networking.enable = true;
  nix-settings.enable = true;
  packages.enable = true;

  virt.enable = false;
  flatpack.enable = false;

  system.stateVersion = "23.11";
}
