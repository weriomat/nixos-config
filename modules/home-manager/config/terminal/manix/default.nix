{pkgs, ...}: {
  # TODO: fix for darwin -> thread panic
  home.packages = with pkgs; [manix];
  # programs.zsh.shellAliases = {
  #   ma = ''
  #     manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix'';
  # };
}
