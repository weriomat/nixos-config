{ pkgs, ... }: {
  # dictonaries
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.de
    aspellDicts.en-computers
    hunspell
    hunspellDicts.en-us
  ];

}
