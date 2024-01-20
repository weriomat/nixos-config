{ pkgs, config, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marts = {
    isNormalUser = true;
    description = "marts";
    # https://christitus.com/vm-setup-in-linux/
    extraGroups = [
      "networkmanager"
      "wheel"
      # "libvirtd"
      # "audio"
      # "video"
      # "disk"
      # "input"
      # "kvm"
      # "libvirt-qemu"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
