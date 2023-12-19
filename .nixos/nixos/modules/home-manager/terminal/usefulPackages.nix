{ pkgs, ... }: {
  # janked from cobalt
  # Zsh packages
  home.packages = with pkgs; [
    # -- terminal emulator utils
    tmux

    # -- general utils
    bat
    curl
    delta
    screen
    dig
    netcat-gnu
    fd
    fzf
    lsof
    imagemagick
    jq
    ncdu
    ripgrep
    zip
    neofetch
    tree
    tealdeer
    tree-sitter
    unzip
    wget

    # -- system level utils
    man
    mlocate
    parted
    killall
    file
    moreutils
    coreutils

    # -- system information
    usbutils
    linuxPackages.cpupower
    pciutils

    # -- bash scripting
    shfmt
    shellcheck

    # -- network
    nmap
    nload
    nethogs
    traceroute
    minio-client
  ];
}
