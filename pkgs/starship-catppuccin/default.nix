# janked from https://gitlab.cobalt.rocks/shared-configs/nixos-ng/-/tree/main/pkgs?ref_type=heads
{
  stdenv,
  fetchFromGitHub,
  flavor ? "mocha",
}:
stdenv.mkDerivation {
  pname = "starship-catppuccin";
  version = "2023-06-13";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/themes
    mv palettes/${flavor}.toml $out/themes/theme.toml
    mv palettes/*.toml $out/themes/
  '';

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
    sha256 = "nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
  };

  description = "Soothing pastel theme for Starship";
}
