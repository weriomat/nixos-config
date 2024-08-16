[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

# Nixos-config
My NixOS Config/ NixDarwin Config

# failing rebuild
due to mounting a nfs share, we can not doublemount it -> remove by 
sudo umount /home/marts/nfs

# NOTE
interernal ips:
nixos-host: 192.168.178.180
nas: 192.168.178.199 oder 192.168.178.198
piserve: 192.168.178.21

# Nix-colors
apps not supported are: btop, starship, firefox, gtk
might be buggy: kitty, helix, waybar
todo: wofi

# NOTES
-> clone into .nixos/nixos since this path is hardcoded into e.g. wallpapers...

## Thank you notice

Special thanks to cobalt for letting me copy his config :)
https://gitlab.cobalt.rocks/shared-configs/nixos-ng/-/blob/main/flake.nix?ref_type=heads

Special thanks to Misterio77 for providing a great starter config
https://github.com/Misterio77/nix-starter-configs/blob/main/standard/nixos/configuration.nix
https://github.com/Misterio77/nix-config/tree/main

Special thanks to nmasur for having a great structured config
https://github.com/nmasur/dotfiles/blob/c53f1470ee04890f461796ba0d14cce393f2b5c3/hosts/lookingglass/default.nix

Special thanks to 
https://github.com/johnk1917/nixrland
cobalt
https://github.com/Frost-Phoenix/nixos-config/tree/main
for "letting" me steal wallpapers

sources i yanked wallpapers from:
https://github.com/D3Ext/aesthetic-wallpapers
https://github.com/42Willow/wallpapers/tree/main
the cattpuccin-discord

A Special Thanks goes out to the maker of fzf for providing a awesome tool as well a good examples
