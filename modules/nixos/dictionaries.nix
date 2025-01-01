{ pkgs, ... }:
{
  # dictionaries
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.de
    aspellDicts.en-computers
    aspellDicts.en-science
    hunspell
    hunspellDicts.en-us
  ];
}
