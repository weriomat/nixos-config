{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  # TODO: make this a module with cacheSize
  services.languagetool = {
    # NOTE: do not forget to set this server as source in firefox
    enable = true;
    port = 8081;
    public = false;
    allowOrigin = "*";
    settings = {
      fasttextModel = "${pkgs.languagetool-ff-model}/share/languagetool/fasttextmodel/lid.176.bin";
      fasttextBinary = "${getExe pkgs.fasttext}";
      cacheSize = 2056;
      languageModel = "${pkgs.languagetool-ngram-ende}/share/languagetool/ngrams";
    };
  };
}
