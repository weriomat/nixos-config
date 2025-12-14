{
  lib,
  python3Packages,
  fetchPypi,
  installShellFiles,
  stdenv,
}:
python3Packages.buildPythonApplication rec {
  pname = "vja";
  version = "4.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TST+r5GGhylxTYcD+mDYlx89cuw25gn4Zgft7gsFVuw=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    click-aliases
    requests
    parsedatetime
    python-dateutil
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    installShellCompletion --cmd vja \
      --bash <(_VJA_COMPLETE=bash_source $out/bin/vja) \
      --zsh <(_VJA_COMPLETE=zsh_source $out/bin/vja) \
      --fish <(_VJA_COMPLETE=fish_source $out/bin/vja)
  '';

  meta = {
    changelog = "https://gitlab.com/ce72/vja/-/blob/${version}/CHANGELOG.md?ref_type=tags";
    description = "CLI client for Vikunja";
    homepage = "https://gitlab.com/ce72/vja";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ weriomat ];
    mainProgram = "vja";
    platforms = lib.platforms.linux;
  };
}
