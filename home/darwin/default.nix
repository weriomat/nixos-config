{ ... }:
{
  imports = [ ../shared ];

  # we dont have to disable anything since it is disables by default
  kitty.enable = true;
  discord.enable = true;

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
