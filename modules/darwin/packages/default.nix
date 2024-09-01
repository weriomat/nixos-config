{pkgs, ...}: {
  # TODO: enable documentation
  # TODO: merge with nixos conf
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    prettyping
    # packages from homebrew
    cadical
    wireshark
    # calibre
    automake
    python311Full
    swiProlog
    z3
    yubikey-manager
    yubikey-personalization
    # texinfo
    lua
    gdbm
    avrdude
    dfu-programmer
    dfu-util
    graphviz
    liblinear
    libspectre
    libssh2
    neovim
    openssh
    pyenv
    teensy-loader-cli
    gnupg

    # now other packages
    kitty
    vim
    wget
    btop
    helix
    lazygit

    nmap
    # TODO: qmk idk
    # qmk

    tldr
    ripgrep
    cloc
    gnumake
    cmake
    cmake-format
    llvm-manpages

    llvm
    llvmPackages_latest.lldb
    clang_15
    clang-tools_15
    extra-cmake-modules
    plasma5Packages.extra-cmake-modules
    mold
    #valgrind

    nixfmt-classic
  ];
}
