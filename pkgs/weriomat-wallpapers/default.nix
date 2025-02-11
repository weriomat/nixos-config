{
  lib,
  stdenv,
  fetchFromGitHub,
  lutgen,
  findutils,
  coreutils,
  ...
}:
stdenv.mkDerivation {
  pname = "weriomat wallpapers";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "weriomat";
    repo = "wallpapers";
    rev = "d3ba0a927a7998a7989a100cf5e849bc725b95ed";
    hash = "sha256-5sUZJrpYuymUwjU30EEWFAY5zoUAFBgokHbiTMjbjfs=";
  };
  buildInputs = [
    lutgen
    findutils
    coreutils
  ];

  buildPhase = ''
    mkdir -p $out/lut_wallpapers
    find . -type f -exec ${lutgen}/bin/lutgen apply {} -p catppuccin-mocha -o $out/lut_wallpapers/{} \;
  '';

  installPhase = ''
    runHook preInstall

    mv $out/lut_wallpapers/* $out
    rm -r $out/lut_wallpapers

    runHook postInstall
  '';

  meta = {
    description = "Wallpaper collection from Weriomat";
    homepage = "https://github.com/weriomat/wallpapers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.weriomat ];
    mainProgram = "wallpapers";
    platforms = lib.platforms.all;
  };
}
