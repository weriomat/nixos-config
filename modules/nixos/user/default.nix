{pkgs, ...}: {
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marts = {
    isNormalUser = true;
    description = "marts";

    # https://christitus.com/vm-setup-in-linux/
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
      "network"
      "dialout"
      "disk"
      "audio"
      "video"
      "disk"
      "input"
    ];

    # set to 1000 to be save
    uid = 1000;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
