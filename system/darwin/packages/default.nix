{ pkgs, ... }:
{
  # TODO: enable documentation
  # TODO: merge with nixos conf
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    localsend
    rectangle
    keepassxc
    bartender
    aldente
    dust
    # packages from homebrew
    cadical
    # calibre
    automake
    swi-prolog
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

    cloc
    gnumake
    cmake
    cmake-format
    llvm-manpages

    llvm
    llvmPackages_latest.lldb
    extra-cmake-modules
    plasma5Packages.extra-cmake-modules
  ];
}
