_: {
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = false;
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";
      videoDrivers = ["amdgpu"];
      displayManager = {
        gdm = {
          enable = false;
        };
        autoLogin = {
          enable = true;
          user = "marts";
        };
        sddm.enable = false;
      };
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
    };

    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };

    dbus.enable = true;
    gvfs.enable = true;
  };
}
