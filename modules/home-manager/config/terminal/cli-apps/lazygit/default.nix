{config, ...}: {
  # Git helper
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        lightTheme = false;
        activeBorderColor = ["#${config.colorScheme.palette.base0B}" "bold"]; # Green
        inactiveBorderColor = ["#${config.colorScheme.palette.base05}"]; # Text
        optionsTextColor = ["#${config.colorScheme.palette.base0D}"]; # Blue
        selectedLineBgColor = ["#${config.colorScheme.palette.base01}"]; # Surface0
        selectedRangeBgColor = ["#${config.colorScheme.palette.base01}"]; # Surface0
        cherryPickedCommitBgColor = ["#${config.colorScheme.palette.base0C}"]; # Teal
        cherryPickedCommitFgColor = ["#${config.colorScheme.palette.base0D}"]; # Blue
        unstagedChangesColor = ["${config.colorScheme.palette.base08}"]; # Red
      };
    };
  };
}
