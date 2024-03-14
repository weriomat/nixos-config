{...}: {
  imports = [./wayland.nix ./greetd.nix];
  services = {
    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    # gnome.gnome-keyring.enable = true;
  };
  # programs.ssh.startAgent = true;
}
