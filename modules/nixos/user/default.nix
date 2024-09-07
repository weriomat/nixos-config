{
  pkgs,
  globals,
  ...
}: {
  config = {
    time.timeZone = "Europe/Berlin";

    users = {
      users = {
        ${globals.username} = {
          isNormalUser = true;
          createHome = true;
          description = "${globals.username}";

          # TODO: add etra groups
          extraGroups = [
            "networkmanager"
            "wheel"
            "wireshark"
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
      mutableUsers = false;
    };

    programs.zsh.enable = true;
  };
}
