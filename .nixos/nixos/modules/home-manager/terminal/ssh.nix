{ pgks, ... }: {
  programs.git = {
    enable = true;
    userName = "weriomat";
    userEmail = "eliasaengel@gmail.com";
    lfs.enable = true;
  };
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";

    extraOptionOverrides = { IdentityFile = "/home/marts/.ssh/github.pub"; };

    extraConfig = "IdentitiesOnly yes";

    matchBlocks = let tu_key = "/home/marts/.ssh/tu-gitlab.pub";
    in {
      "github.com" = { user = "git"; };
      "git.tu-berlin.de" = {
        user = "git";
        identityFile = tu_key;
      };
    };
  };
}
