{pkgs, ...}: {
  # Enable polkit
  security.polkit.enable = true;

  # TODO: https://github.com/niksingh710/ndots/blob/master/nixos/optional/authentication.nix
  # TODO: here
  # https://github.com/niksingh710/ndots/blob/19757f8b37013323b2cc681b4e46ebce5fef44c3/nixos/optional/authentication.nix

  # TODO: here
  home.packages = with pkgs; [polkit_gnome];

  # Enable polkit for system wide autz, required as part of gnome-compat
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    partOf = ["graphical-session.target"];
    description = "Gnome polkit agent";
    script = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    unitConfig = {ConditionUser = "!@system";};
  };

  # TODO: here
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   Unit.Description = "polkit-gnome-authentication-agent-1";

  #   Install = {
  #     WantedBy = ["graphical-session.target"];
  #     Wants = ["graphical-session.target"];
  #     After = ["graphical-session.target"];
  #   };

  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };
}
