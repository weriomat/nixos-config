{
  lib,
  python3Packages,
  ddcutil,
  swayosd,
}:

python3Packages.buildPythonPackage {
  pname = "external-monitor-brightness";
  version = "0.1.0";
  pyproject = true;

  src = ./.;

  build-system = [ python3Packages.uv-build ];

  dependencies = [
    ddcutil
    swayosd
  ];

  meta = {
    description = "Small helper to set brightness for external screens";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ weriomat ];
    mainProgram = "external-monitor-brightness";
    platforms = lib.platforms.linux;
  };
}
