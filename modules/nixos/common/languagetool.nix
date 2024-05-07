{...}: {
  services.languagetool = {
    enable = true;
    port = 8081;
    public = false;
    allowOrigin = null;
    settings = {
      # fasttextModel
      # fasttextBinary
      # languageModel
      cacheSize = 2500;
    };
  };
}
