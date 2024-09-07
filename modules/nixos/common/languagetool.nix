{globals, ...}: {
  # TODO: make this a module with cacheSize
  services.languagetool = {
    # dont forget to swtich to local server in firefox
    enable = true;
    port = 8081;
    public = false;
    allowOrigin = "*";
    settings = {
      # TODO: here
      # fasttextModel
      # fasttextBinary
      # languageModel
      cacheSize =
        if globals.laptop
        then 10000
        else 2500;
    };
  };
}
