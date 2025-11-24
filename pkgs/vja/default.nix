{
  buildPythonPackage,
  fetchPypi,
  lib,
}:
buildPythonPackage rec {
  pname = "vja";
  version = "4.10.1";

  src = fetchPypi {
    inherit pname version;
    hash = lib.fakeHash;
  };
  # src = fetchFromGitLab {
  #   owner = "ce72";
  #   repo = "vja";
  #   rev = "c409c102fcc026d2fd7b349ad75c8bb7832d0ea2";
  #   hash = "sha256-Jiuw13cjK1usnlllnMDWv8EFPe813HmwjhAsuMnNozU=";
  # };
  pyproject = true;
}
