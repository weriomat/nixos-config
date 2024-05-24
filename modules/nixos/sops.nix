_: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/marts/.config/sops/age/keys.txt";

    secrets.borg-key = {
      # owner = "marts";
    };
  };
}
