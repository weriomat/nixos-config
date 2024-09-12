{pkgs, ...}: {
  home.packages =
    # TODO: unify
    if pkgs.stdenv.isLinux
    then
      with pkgs; [
        # -- system level utils
        mlocate
        parted
        # -- system information
        usbutils
        linuxPackages.cpupower
        pciutils # lspci, setpci
        # -- network
        # networking tools
        nethogs
        traceroute
      ]
    else [];
}
