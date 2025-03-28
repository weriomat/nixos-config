{
  pkgs,
  globals,
  ...
}:
{
  time.timeZone = "Europe/Berlin";

  users = {
    users.${globals.username} = {
      inherit (globals) uid;
      isNormalUser = true;
      createHome = true;
      description = "${globals.username}";
      extraGroups = [
        "networkmanager"
        "tty"
        "wheel"
        "network"
        "dialout"
        "disk"
        "audio"
        "video"
        "disk"
        "input"
      ];
      hashedPassword = "$y$j9T$NbSJKRlQhIdwZauz4m2uX1$AdlYNcSkXN2DWZ0Q/kETh/lUrUGS5.3IMs.ReoLD2NB";
      homeMode = "755";
      group = globals.username;
    };
    groups.${globals.username} = { };

    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };

  programs.zsh.enable = true;
}
