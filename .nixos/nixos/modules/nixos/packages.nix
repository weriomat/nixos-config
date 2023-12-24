{ pkgs, ... }: {

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nixos-rebuild
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    # nix 
    nixfmt
    nixpkgs-fmt
    nixpkgs-lint
    statix
    # nix-indent

    neofetch

    (haskellPackages.ghcWithPackages (pkgs:
      with pkgs; [
        stack
        cabal-install
        MonadRandom
        multiset-comb
        haskell-language-server
      ]))

    # build tools
    autoconf
    gnumake

    # -- Dev tools --
    ansible
    nodejs
    # nodePackages.neovim
    go
    openjdk
    (pkgs.python3.withPackages (p:
      with p; [
        pandas
        isort
        python-lsp-server
        black
        pygments
        requests
        keyring
        numpy
        dnslib
        pytest
        scipy
        git-filter-repo
        yt-dlp
      ]))
    python3

    gcc
    llvm
    clang_15
    clang-tools_15
    # cmake
    extra-cmake-modules
    llvmPackages_latest.lldb
    plasma5Packages.extra-cmake-modules
    mold
    valgrind
    rustup
    unstable.llvm
    unstable.clang_15
    unstable.clang-tools_15
    unstable.cmake
    unstable.extra-cmake-modules
    # unstable.llvmPackages_latest.lldb
    unstable.plasma5Packages.extra-cmake-modules
    unstable.mold
    unstable.valgrind
  ];
}
