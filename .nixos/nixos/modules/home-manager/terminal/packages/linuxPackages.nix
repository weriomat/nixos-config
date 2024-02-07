{pkgs, ...}: {
  home.packages =
    if pkgs.stdenv.isLinux
    then
      with pkgs; [
        # -- system level utils
        mlocate
        parted
        # -- system information
        usbutils
        linuxPackages.cpupower
        pciutils
        # -- network
        # networking tools
        nethogs
        traceroute
      ]
    else [];
}
