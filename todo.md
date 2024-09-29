# TODOS
https://github.com/kinzoku-dev/neovim

1. fix config imports 
-> modules to modules, home manager to home...

-> new fonts: https://gitlab.com/hmajid2301/nixicle/-/tree/main/packages/monolisa/MonoLisa
-> cleanup pkgs thingie, idk why pkgs.callPackage is not here
-> laptop hibernate
-> laptop borg 
-> vaultwarden
firefox-sync
https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.automounts
https://nix-community.github.io/home-manager/options.xhtml#opt-launchd.agents._name_.config.LimitLoadToSessionType
https://nix-community.github.io/home-manager/options.xhtml#opt-home.language.name
https://nix-community.github.io/home-manager/options.xhtml#opt-home.keyboard.model
https://github.com/JaysFreaky/fancontrol-gui
https://coredns.io/
https://github.com/joshmedeski/sesh
https://github.com/joshmedeski/tmux-fzf-url
https://github.com/joshmedeski/dotfiles
https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/system/systemd-lock-handler.nix
https://sr.ht/~whynothugo/systemd-lock-handler/
https://nixos.org/manual/nixos/unstable/#module-services-parsedmarc
https://nixos.org/manual/nixos/unstable/#module-services-parsedmarc-grafana-geoip
https://nixos.org/manual/nixos/unstable/#module-services-networking-dnsmasq
https://nixos.org/manual/nixos/unstable/#module-services-glance
https://nixos.org/manual/nixos/unstable/#module-services-gitlab
https://nixos.org/manual/nixos/unstable/#module-services-filesender
https://nixos.org/manual/nixos/unstable/#sec-gpu-accel
https://nixos.org/manual/nixos/unstable/#sec-custom-ifnames
https://nixos.org/manual/nixos/unstable/#module-services-nextcloud
https://nixos.org/manual/nixos/unstable/#module-services-keycloak
https://nixos.org/manual/nixos/unstable/#sec-systemd-sysusers
https://nixos.org/manual/nixos/unstable/#module-postgresql
https://nixos.org/manual/nixos/unstable/#module-security-acme
https://nixos.org/manual/nixos/unstable/#module-services-mailman
https://search.nixos.org/options?channel=24.05&from=0&size=50&sort=relevance&type=packages&query=systemd.sysuser
https://search.nixos.org/options?channel=24.05&show=services.opensmtpd.serverConfiguration&from=0&size=50&sort=relevance&type=packages&query=opensmt
https://dataswamp.org/~solene/2018-09-06-openbsd-opensmtpd-relay.html
https://wiki.archlinux.org/title/Msmtp
https://marlam.de/msmtp/msmtp.html#Transport-Layer-Security
https://wiki.archlinux.org/title/OpenSMTPD
https://www.davd.io/posts/2021-12-18-freebsd-mail-server-part-1/
https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/amdgpu.nix
https://search.nixos.org/options?channel=unstable&show=hardware.amdgpu.opencl.enable&from=0&size=50&sort=relevance&type=packages&query=hardware.amd
https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/acpid.nix
https://github.com/NixOS/nixpkgs/tree/nixos-unstable/nixos/modules/services/hardware
https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/thermald.nix
https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/hddfancontrol.nix
https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/amdvlk.nix

# image hosting server
https://nixos.org/manual/nixos/unstable/#module-services-pict-rs
immich

# pingvinshare
https://nixos.org/manual/nixos/unstable/#module-services-pingvin-share

# analytics for website
https://nixos.org/manual/nixos/unstable/#module-services-plausible

-> generate a secret key
`openssl rand -base64 64`

# mosquitto
https://nixos.org/manual/nixos/unstable/#module-services-mosquitto
-> switch to tls
https://search.nixos.org/options?channel=24.05&size=50&sort=relevance&type=packages&query=mosquitto

https://nixos.org/manual/nixos/unstable/#module-services-meilisearch
-> fulltext search
https://search.nixos.org/options?channel=24.05&show=services.meilisearch.listenPort&from=0&size=50&sort=relevance&type=packages&query=meilisearch
https://www.meilisearch.com/docs/learn/self_hosted/getting_started_with_self_hosted_meilisearch#search


# git

programs.git.extraConfig = {
                init = { defaultBranch = "main"; };
                core = {
                    excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
                };

# boot
<!-- # Boot settings: clean /tmp/, latest kernel and enable bootloader -->
    <!-- boot = { -->
        <!-- cleanTmpDir = true; -->
        <!-- loader = { -->
        <!-- systemd-boot.enable = true; -->
        <!-- systemd-boot.editor = false; -->
        <!-- efi.canTouchEfiVariables = true; -->
        <!-- timeout = 0; -->
        <!-- }; -->
    <!-- }; -->

# fonts
<!-- # Install fonts -->
    <!-- fonts = { -->
        <!-- fonts = with pkgs; [ -->
            <!-- jetbrains-mono -->
            <!-- roboto -->
            <!-- openmoji-color -->
            <!-- (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) -->
        <!-- ]; -->

        <!-- fontconfig = { -->
            <!-- hinting.autohint = true; -->
            <!-- defaultFonts = { -->
              <!-- emoji = [ "OpenMoji Color" ]; -->
            <!-- }; -->
        <!-- }; -->
    <!-- }; -->

# TODO:
matrix

# TAKE a look at
https://github.com/glanceapp/glance
https://github.com/qdm12/ddns-updater
https://localsend.org/de
https://github.com/apernet/OpenGFW?tab=readme-ov-file
https://github.com/FlareSolverr/FlareSolverr
https://nixos.org/manual/nixos/unstable/#module-services-anki-sync-server

# new in 24.11
localsend
playerctl
flaresolver

sound options
https://nixos.org/manual/nixos/unstable/release-notes#sec-release-24.11-migration-sound

# config files right with boxxy lol 
`https://github.com/queer/boxxy`

# Email, cant be bothered rn
- notmuch 
- programs.alot `https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alot.enable`
- imapnotify `services.imapnotify.enable`
- getmail `services.getmail`
- mu mail indexer `programs.mu`
- afew -> email tagging
- liier -> synchronizaiton btewwen notmuch and gmail

- TODO: newsboat -> RSS reader for terminals

- arrpc -> discord rpc

- Refactor user management
- Use Homemanger bundles for config
- Hyperland
- configure bootloader -> https://github.com/vimjoyer/nixconf/blob/main/hosts/laptop/configuration.nix
- configure monitors
- set fonts -> maybe buy comic code
- configure neovim -> logamaster
- configure rust
- configure gpg

# links to take a look at
https://nix.dev/tutorials/nix-language
https://nix.dev/manual/nix/2.18/language/builtins
https://nix.dev/manual/nix/2.18/command-ref/nix-instantiate
https://nixos.wiki/wiki/Configuration_Collection

# hyprland configs

https://github.com/sioodmy/dotfiles/tree/main/home/rice/hyprland

https://github.com/redyf/nixdots/tree/main/home/desktop/desktop/hyprland
https://github.com/dedSyn4ps3/nixos_desktop_configs/tree/main/waybar
https://github.com/aliyss/dotfiles/tree/master/hypr
https://github.com/IogaMaster/dotfiles/blob/main/modules/nixos/desktop/hyprland/default.nix
https://github.com/sioodmy/dotfiles/tree/main/home/rice/hyprland

https://github.com/sioodmy/dotfiles/tree/main/system/wayland


https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/swaylock/config?ref_type=heads
https://github.com/iancleary/nixos-config
https://gist.github.com/johanwiden/900723175c1717a72442f00b49b5060c

# Configs to take a look at
https://github.com/vimjoyer/nixconf
https://github.com/aliyss/dotfiles
https://github.com/Redyf/nixdots
https://github.com/notusknot/dotfiles-nix
https://github.com/IogaMaster/dotfiles
https://github.com/sioodmy/dotfiles
https://github.com/NotAShelf/nyx
https://github.com/AlphaTechnolog/nixdots
https://github.com/johnk1917/nixrland
https://github.com/skiletro/nixfiles
https://github.com/iynaix/dotfiles
https://github.com/IogaMaster/dotfiles
https://github.com/Redyf/nixdots
https://github.com/dragonblade316/dotfiles
https://github.com/arclight443/config
https://github.com/kinzoku-dev/neovim
https://github.com/kinzoku-dev/nebula
https://github.com/NobbZ/nixos-config/blob/main/flake.nix
