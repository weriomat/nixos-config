# NOTES about my config or general notes

## TODO

MTR-Exporter -> this is cool for hosts

## Notes

queue shell commands with pueue

## Package

just import the thingies you need
prefetch url -> `nix shell nixpkgs#nurl` `nurl "https://github.com/weriomat/wallpapers"`

## MA -> local search for attrs

## comma

use `comma` or `,` to run a app with help of nix-db without installing

## Kill a process

<ctrl + z> moves it to backgroun -> like & at end
-> kill %1 -> to kill background process

## zsh commands

`<ctrl> + r` -> search shell history
`<ctrl> + t` -> search through files in current dir with currently fzf
`<alt> + c`  -> search through subfolders and folders of current dir

## fzf

fzf picks up `**` ->
`kill -9 ** <TAB>`
`ssh **<TAB>`
`cd **<TAB>`
`cd ~/.nixos/nixos/**<TAB>`

## glow -> view md in cli

## ma -> seach local comments for nix attrs

## batgrep

## batdiff

## nd

## check-flake

## format-flake

## ho

fzf -> hx

## gdiff

## kp

-> kill a process

## fh

-> fho, fhc

## sysz

## ytfzf -> watch yt with fzf

## clerk mpd client

## bookmark manager

buku
`https://github.com/jarun/Buku`
-> `fb` opens, `fbu` update, `fbw` write

## better cd

`cdd`, `cdf`

## search fif

## command

`command <cmd>` executes the command and not any aliases ->
`command ls` -> executes `ls` instead of `eza`

## list all running processes

ps aux
-> hierarchisch ps -axjf
-> filter by user ps -U

## ip addr

## ip a

## ifconfig

## ethtool

## add sth to a list

networking.timeServers = options.networking.timeServers.default
++ [ "pool.ntp.org" ];
-> adding to attr set ist just adding a item ig in another location
-> updating attr set -> just set value with lib.mkForce ...
-> update attr set with //

## gpu test amd

`nix shell nixpkgs#radeontop`
`radeontop`
-> stresstest
`nix shell nixpkgs#glmark2`
`glmark2`
`nix shell nixpkgs#lshw`
`sudo lshw -C display -short`
`https://wiki.archlinux.org/title/Hardware_video_acceleration`
`nix shell nixpkgs#libva-utils -c vainfo`
`nix shell nixpkgs#vdpauinfo -c vdpauinfo`
`firefox about:support`

## clipboard

$mainMod o / $mainMod SFT o -> copy/ delete from clipboard
`cliphist wipe` -> delete entire history

## build packages

`nix-shell -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'`
`cd $(mktemp -d)`
`unpackPhase`
`patchPhase`
`updateAutotoolsGnuConfigScriptsPhase`
`configurePhase`
`buildPhase`
``

## unset histroy in zsh

`fc -p` -> starts shell in inmemory mode

## portscan

get subnet from `ip a`
`sudo nmap -sn <output>`

## ssh keygen

update thingie
`ssh-keygen -R 192.168.178.32`

## nix does package exist

`nix why-depends /run/current-system nixpkgs#<package>`

## nix-tree

`nix shell nixpkgs#nix-tree -c nix-tree`

### current system

`nix-tree /nix/var/nix/profiles/system`

### Build time dependencies of a flake on the current directory

nix-tree --derivation '.#'

### Same thing works for any flake reference

nix-tree --derivation 'nixpkgs#asciiquarium'

### Run nix-tree on a flake reference of a nixosConfiguration

`
nix build --print-out-paths --no-link '.#nixosConfigurations.foo.
config.system.build.toplevel'
nix-tree '.#nixosConfigurations.foo.config.system.build.toplevel'
`

### transitive dependencies of a package

```bash
# Build in a temporary chroot store and examine the output
nix build --store /tmp/chroot-store 'nixpkgs#hello' --print-out-paths | \
 xargs -o nix-tree --store /tmp/chroot-store
```

### list packages on current system using more than 500MB of disk space

`nix shell nixpkgs#graphviz nixpkgs#nix-du -c \
''nix-du -s=500MB --root '/run/current-system/sw/' | dot -Tsvg > store.svg''`
or `-n <num>` for the number of biggest files

`https://github.com/craigmbooth/nix-visualize`

## fonts

list -> `fc-list`

## zramswap

`zramctl`

## rotate gpg key

notes [here](https://unix.stackexchange.com/questions/184947/how-to-import-secret-gpg-key-copied-from-one-machine-to-another)
-> follow guide from [here](https://github.com/drduh/YubiKey-Guide/tree/master?tab=readme-ov-file#create-certify-key)
-> maybe sign new key with old key
-> once all written to bakup thingie
-> exported to yubikey
-> write pubkey to laptop via usb stick
-> `gpg --import <pubkey.asc>`
-> `gpg -k` -> from new key keyid
-> `export KEYID=<id>`
trust new key

```bash
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
trust
5
y
save
EOF
```

`gpg --card-status`
-> verify that sth is under General key info

### test

```bash
echo "\ntest message string" | \
  gpg --encrypt --armor \
      --recipient $KEYID --output encrypted.txt
```

```bash
gpg --decrypt --armor encrypted.txt
```

### Add keys to github/gitlab

`ssh-add -L` -> should give new key
rotate `~/.ssh/id_rsa_yubikey.pub`
via first backing up that one
`ssh-add -L > ~/.ssh/id_rsa_yubikey.pub`
-> verify that only the one key interesd is present

-> add `pubkey.asc` -> as new
[gpg key](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account),
add `id_rsa_yubikey.pub` as ssh loginkey
-> rotate siging key in git config in nixos
