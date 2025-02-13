{ pkgs, ... }:
{
  home.packages = [ pkgs.manix ];
  # TODO: here paths
  programs.zsh.shellAliases = {
    ma = ''${pkgs.manix}/bin/manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix'';
  };
}
