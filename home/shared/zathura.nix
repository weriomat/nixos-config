{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set synctex true
      set synctex-editor-command "${getExe pkgs.texlab} inverse-search -i %{input} -l %{line}"
    '';
  };
}
