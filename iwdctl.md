# Notes

## IWCTL

if wifi is turned off than we turn off iwd

-> turn on adapter
`iwctl device name set-property Powered on`
`iwctl adapter <name> set-property Powered on`

-> get info
`nix run nixpkgs#iw -- dev`

-> list stations
`iwctl station list`

-> show state of station `<int>`
`iwctl station <int> show`

-> scan
`iwctl station <int> scan`

-> list available networks
`iwctl station <int> get-networks`

-> forget available netwokr
`iwctl known-networks SSID forget`

-> connect to wifi
`iwctl station wlan0 connect "FRITZ!Box 7362 SL"`
`iwctl station name connect-hidden SSID`

-> disconnect
`iwctl station device disconnect`

### WPS/WSC

list
`iwctl wsc list`
`iwctl wsc device push-button`
-> push button on router afterwards

## reapply networkd config networkd link

```bash
sudo udevadm control --reload
sudo ip link set <int> down
sudo udevadm trigger --verbose --settle --action add /sys/class/net/<int>
```

## impala

### Global

Tab or Shift + Tab: Switch between different sections.

j or Down : Scroll down.

k or Up: Scroll up.

ctrl+r: Switch adapter mode.

?: Show help.

esc: Dismiss the different pop-ups.

q or ctrl+c: Quit the app.

### Device

i: Show device information.

o: Toggle device power.
Station

s: Start scanning.

Space: Connect/Disconnect the network.

### Known Networks

a: Enable/Disable auto-connect.

d: Remove the network from the known networks list.

### Access Point

n: Start a new access point.

x: Stop the running access point.
