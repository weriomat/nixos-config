# stolen from cobalt
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    powertop
    linuxPackages.cpupower
  ];
  powerManagement.cpuFreqGovernor = "schedutil";

  # Enable upower for bat management
  # the specific scheduler/ handling will be different on work and rw due to differences
  # in the CPU archictectures
  services = {
    power-profiles-daemon.enable = false;
    upower.enable = true;
    tlp = {
      enable = true;
      settings = {
        # CPU handling
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        SCHED_POWERSAVE_ON_AC = 0;
        SCHED_POWERSAVE_ON_BAT = 1;

        # Battery care
        START_CHARGE_THRESH_BAT0 = 70;
        STOP_CHARGE_THRESH_BAT0 = 80;
        RUNTIME_PM_ON_BAT = "auto";

        # Devices
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth wifi";
      };
    };
  };
}
