{ pkgs, ... }: {
  # Enable polkit
  security.polkit.enable = true;

  home.packages = with pkgs; [ polkit_gnome ];

  # Enable polkit for system wide autz, required as part of gnome-compat 
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    partOf = [ "graphical-session.target" ];
    description = "Gnome polkit agent";
    script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    unitConfig = { ConditionUser = "!@system"; };
  };
}
