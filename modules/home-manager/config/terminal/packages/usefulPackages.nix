{pkgs, ...}: {
  # janked from cobalt
  # Zsh packages
  home.packages = with pkgs; [
    alejandra
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
    # ncdu
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
    killall
    file
    moreutils
    coreutils

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
    minio-client
  ];
}
