# Package
just import the thingies you need
prefetch url -> `nix shell nixpkgs#nurl` `nurl "https://github.com/weriomat/wallpapers"`
# MA -> local search for attrs

# Kill a process
<ctrl + z> moves it to backgroun -> like & at end
-> kill %1 -> to kill background process

# zsh commands
`<ctrl> + r` -> search shell history
`<ctrl> + t` -> search through files in current dir with currently fzf
`<alt> + c`  -> search through subfolders and folders of current dir

# fzf
fzf picks up `**` -> 
`kill -9 ** <TAB>`
`ssh **<TAB>`
`cd **<TAB>`
`cd ~/.nixos/nixos/**<TAB>`

# glow -> view md in cli

# ma -> seach local comments for nix attrs
# batgrep 
# batdiff
# nd
# check-flake
# format-flake

# ho
fzf -> hx

# gdiff

# kp
-> kill a process

# fh
-> fho, fhc

# sysz

# ytfzf -> watch yt with fzf
# clerk mpd client

# bookmark manager
buku
`https://github.com/jarun/Buku`
-> `fb` opens, `fbu` update, `fbw` write

# better cd
`cdd`, `cdf`

# search fif

# command
`command <cmd>` executes the command and not any aliases -> `command ls` -> executes `ls` instead of `eza` 

# list all running processes 
ps aux 
-> hierarchisch ps -axjf
-> filter by user ps -U 
# ip addr
# ip a
# ifconfig
# ethtool

# add sth to a list 
networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
-> adding to attr set ist just adding a item ig in another location
-> updating attr set -> just set value with lib.mkForce ...
-> update attr set with //
