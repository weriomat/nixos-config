{ inputs, pkgs, ... }: {
  home-manager.user.marts = {
    # programs.git.enable = true;
    # programs.git.userEmail = "weriomat";
    # programs.git.userName = "eliasaengel@gmail.com";
    # programs.git.lfs.enable = true;
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

      extraOptionOverrides = {
        # IdentityFile = toString (inputs.keys + "/home/marts/.ssh/github.pub");
        IdentityFile = "/home/marts/.ssh/github.pub";
      };

      extraConfig = "IdentitiesOnly yes";

      matchBlocks = { "github.com" = { user = "git"; }; };
    };
  };
}
