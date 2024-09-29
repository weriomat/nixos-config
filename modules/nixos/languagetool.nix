_: {
  # TODO: make this a module with cacheSize
  services.languagetool = {
    # NOTE: do not forget to set this server as source in firefox
    enable = true;
    port = 8081;
    public = false;
    allowOrigin = "*";
    settings = {
      # TODO: here
      # fasttextModel
      # fasttextBinary
      # languageModel
      cacheSize = 2056;
    };
  };
}
