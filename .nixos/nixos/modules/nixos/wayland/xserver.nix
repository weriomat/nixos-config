{ ... }: {

  # TODO: gnome -> hyperland
  services = {
    xserver = {
      # Enable the X11 windowing system.
      # enable = true;
      # Configure keymap in X11
      layout = "us";
      # xkbVariant = "";
      # videoDrivers = [ "amdgpu" ];
      displayManager.gdm = {
        # enable = true;
        enable = false;
        #   wayland = true;
      };
      displayManager.autoLogin = {
        enable = true;
        user = "marts";
      };
      displayManager.sddm.enable = false;
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;

      # trackpad
      # libinput = {
      #   enable = true;
      #   # mouse = { accelProfile = "flat"; };
      # };
    };

    printing = {
      # Enable CUPS to print documents.
      enable = true;
    };
    dbus.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
