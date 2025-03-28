# from `https://github.com/fufexan/dotfiles/blob/main/system/programs/gamemode.nix`
_: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  # services.pipewire.lowLatency.enable = true;
  # imports = [
  #   inputs.nix-gaming.nixosModules.pipewireLowLatency
  # ];
}
