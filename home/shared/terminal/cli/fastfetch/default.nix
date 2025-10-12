{ config, ... }:
{
  programs = {
    zsh.shellAliases = {
      neofetch = "${config.programs.fastfetch.package}/bin/fastfetch";
      fetch = "${config.programs.fastfetch.package}/bin/fastfetch";
    };
    fastfetch.enable = true;
  };
}
