# Notes on how to use a repl for nixosConfigurations

```bash
nix repl

nixos-rebuild repl # instance config
nh darwin repl # nh does provide the same facilities
nh os repl
```

```nix
:lf .
:lf nixpkgs
:r # reload all expr
:a legacyPackages.x86_64-linux
# -> now can use lib functions normally
```
