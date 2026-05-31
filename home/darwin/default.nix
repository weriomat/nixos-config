{ pkgs, ... }:
{
  imports = [ ../shared ];

  # fix apps finable in spotlight
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  # we dont have to disable anything since it is disables by default
  kitty.enable = true;
  discord.enable = true;
  thunderbird.enable = true;

  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  programs.zathura = {
    enable = true;
    extraConfig = ''
      set synctex true
      set synctex-editor-command "${pkgs.lib.getExe pkgs.texlab} inverse-search -i %{input} -l %{line}"
    '';
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
