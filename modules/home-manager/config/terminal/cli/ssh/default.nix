{
  pkgs,
  lib,
  ...
}: {
  # programs.git = lib.mkIf pkgs.stdenv.isLinux {
  #   enable = true;
  #   userName = "weriomat";
  #   userEmail = "eliasaengel@gmail.com";
  #   lfs.enable = true;
  #   extraConfig = {init = {defaultBranch = "main";};};
  # };
  # programs.ssh = lib.mkIf pkgs.stdenv.isLinux {
  #   enable = true;
  #   compression = true;
  #   controlMaster = "auto";
  #   extraOptionOverrides = {
  #     IdentityFile = "/home/marts/.ssh/id_ed25519.pub";
  #   };

  #   extraConfig = "IdentitiesOnly yes";

  #   matchBlocks = let
  #     tu_key = "/home/marts/.ssh/tu-gitlab.pub";
  #   in {
  #     "github.com" = {user = "git";};
  #     "git.tu-berlin.de" = {
  #       user = "git";
  #       identityFile = tu_key;
  #     };
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
