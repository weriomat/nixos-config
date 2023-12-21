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
    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
    nload
    nethogs
    traceroute
    minio-client
  ];
}