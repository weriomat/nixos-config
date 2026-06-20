_: {
  # https://github.com/aristocratos/btop/issues/1283#issuecomment-3725082807
  systemd.tmpfiles.rules = [
    "Z /sys/class/powercap/intel-rapl:0/energy_uj 0444 root root - -"
  ];
}
