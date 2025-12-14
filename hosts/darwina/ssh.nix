_: {
  programs.gnupg.agent = {
    #TODO: https://github.com/jakehamilton/config/blob/main/modules/darwin/security/gpg/default.nix
    enable = true;
    enableSSHSupport = true;
  };
}
