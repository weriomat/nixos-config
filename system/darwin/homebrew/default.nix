{ ... }:
{
  # We install Vorta/ Borgbackup with proper fuse support, see https://github.com/borgbackup/homebrew-tap and https://vorta.borgbase.com/install/macos/
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation = {
      autoUpdate = true; # update during rebuild
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
    };
    taps = [ "borgbackup/tap" ];
    brews = [ "borgbackup/tap/borgbackup-fuse" ];
    casks = [
      "vorta" # TODO: package or use with brew
      "macfuse"
      "nvidia-nsight-compute"
    ];
  };
}
