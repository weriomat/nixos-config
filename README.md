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

### Switch to iwd from wpa_supplicant

```nix
networking.iwd.enable = true # own option
```

migrate the connections

```bash
sudo su
cd /etc/NetworkManager/system-connections
mkdir ../system-connections-iwd
for f in *; do grep -v \
'^\(mac-address\|interface-name\|permissions\|bssid\)=' "$f" \
> ../system-connections-iwd/"$f"; done
chmod 0600 ../system-connections-iwd/*
cd /etc/NetworkManager
mv system-connections system-connections-backup
dbus-send --system --print-reply --dest=org.freedesktop.NetworkManager \
/org/freedesktop/NetworkManager/Settings org.freedesktop.NetworkManager.Settings.ReloadConnections
sleep 1
mv system-connections-iwd system-connections
dbus-send --system --print-reply --dest=org.freedesktop.NetworkManager \
/org/freedesktop/NetworkManager/Settings org.freedesktop.NetworkManager.Settings.ReloadConnections
```

## CAPTCHA PORTAL DB

By default their dns server is `172.18.0.1`.

```bash
dig login.wifionice.de @172.18.0.1
firefox https://<ans>
firefox https://10.101.64.121
```

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

### Frost-Phoenix

Special thanks to [Frost-Phoenix](https://github.com/Frost-Phoenix) for having
a great hyprland desktop [configuration](https://github.com/Frost-Phoenix/nixos-config/tree/catppuccin).

### Redyf

Special thanks to [Redyf](https://github.com/redyf) for having a structured
[configuration](https://github.com/redyf/nixdots)

### XNM1

Special thanks to [XMN1](https://github.com/XNM1) for having a great security
[configuration](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/tree/main)

### niksingh710

Special thanks to [niksingh710](https://github.com/niksingh710) for having a great
[configuration](https://github.com/niksingh710/ndots)

### different-name

Special thanks to [different-name](https://github.com/different-name) for having
a great [configuration](https://github.com/different-name/nix-files)

### Sly-Harvey

Special thanks to [Sly-Harvey](https://github.com/Sly-Harvey) for having a great
[configuration](https://github.com/Sly-Harvey/NixOS)

## The maker of fzf

A special thanks goes out to the maker of [fzf](https://github.com/junegunn/fzf)
for providing a awesome tool as well a good examples.
