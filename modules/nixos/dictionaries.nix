{ pkgs, ... }:
{
  # dictionaries
  environment.systemPackages = [
    pkgs.aspell
    pkgs.aspellDicts.en
    pkgs.aspellDicts.de
    pkgs.aspellDicts.en-computers
    pkgs.aspellDicts.en-science
    pkgs.hunspell
    pkgs.hunspellDicts.en-us
  ];
}
