{
  pkgs,
  inputs,
  globals,
  ...
}:
{
  imports = [
    ../shared
    ./xdg.nix
    ./obs.nix
    ./supersonic.nix
  ];

  # NOTE: vscodium disabled since tex stuff works
  discord.enable = true;
  firefox = {
    enable = true;
    arkenfox.enable = true;
  };
  hyprland.enable = true;
  kitty.enable = true;
  thunderbird.enable = true;

  # TODO: gtk, hyprland, waybar
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };


  # TODO: nice hud to see gpu stats; with steam
  # programs.mangohud = {};

  services = {
    # NOTE: notifications about power
    poweralertd.enable = true;

    # set this up for macos s well
    pueue = {
      enable = true;
      settings = {
        daemon.default_parallel_tasks = 2;
        client.dark_mode = true;
      };
    };
  };

  manual = {
    html.enable = true; # `home-manager-help`
    json.enable = true; # creates all hm options as a json
    manpages.enable = true; # `man home-configuration.nix`
  };

  home = rec {
    inherit (globals) username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11"; # Has not to be changed
    packages = builtins.attrValues (import ./scripts { inherit pkgs globals inputs; });
    # Add ./local/bin to $PATH
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
    preferXdgDirectories = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
