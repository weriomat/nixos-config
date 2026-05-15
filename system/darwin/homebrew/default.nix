{ config, ... }:
let
  cfg = config.homebrew;
in
{
  # FIXME: when 26.05 lands this will be deprecated
  programs.zsh.interactiveShellInit = ''
    eval "$(${cfg.brewPrefix}/brew shellenv zsh)"
  '';

  # We install Vorta/ Borgbackup with proper fuse support, see https://github.com/borgbackup/homebrew-tap and https://vorta.borgbase.com/install/macos/
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true; # update during rebuild
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
      lockfiles = false; # Don't save lockfile (since running from anywhere)
    };
    taps = [ "borgbackup/tap" ];
    brews = [ "borgbackup/tap/borgbackup-fuse" ];
    casks = [
      "vorta" # TODO: package or use with brew
      "macfuse"
    ];
  };
}
