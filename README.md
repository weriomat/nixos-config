# Nixos-config

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
My NixOS Config/ NixDarwin Config

## NOTES

### DNS

nm does not touch /etc/resolv.conf -> dns settings from e.g. wireguard will get ignored...

### IPS

interernal ips:
nixos-host: 192.168.178.180
nas: 192.168.178.199 oder 192.168.178.198
piserve: 192.168.178.21

## Nix-colors

apps not supported are: btop, starship, firefox, gtk
might be buggy: kitty, helix, waybar
todo: wofi

## Thank you notice

### Cobalt

Special thanks to [cobalt](cobalt.rocks) and his [nix-config](https://gitlab.cobalt.rocks/shared-configs/nixos-ng)
for letting me copy his config :)

### Misterio77

Special thanks to [Misterio77](https://github.com/Misterio77) for providing a
[great starter config](https://github.com/Misterio77/nix-starter-configs) as
well as his own [config](https://github.com/Misterio77/nix-config/tree/main)

### nmasur

Special thanks to [nmasur](https://github.com/nmasur) for having a
great structured [config](https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix)

## The maker of fzf

A special thanks goes out to the maker of [fzf](https://github.com/junegunn/fzf)
for providing a awesome tool as well a good examples.
