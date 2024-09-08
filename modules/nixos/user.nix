{
  pkgs,
  globals,
  ...
}: {
  time.timeZone = "Europe/Berlin";

  users = {
    users = {
      ${globals.username} = {
        isNormalUser = true;
        createHome = true;
        description = "${globals.username}";

        extraGroups = [
          "networkmanager"
          "wheel"
          "network"
          "dialout"
          "disk"
          "audio"
          "video"
          "disk"
          "input"
        ];

        uid = 1000;
        homeMode = "755";
      };
    };
    defaultUserShell = pkgs.zsh;
    # TODO: make pasword file here
    # mutableUsers = false;
  };

  programs.zsh.enable = true;
}
