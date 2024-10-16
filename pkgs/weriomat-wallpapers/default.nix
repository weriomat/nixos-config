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
    rev = "387d403644f2a7a25808d3b61a12dc5c69d3ec16";
    hash = "sha256-9krfY9V6lph+fHGcv4fiOrJYGHTQSNaye7t5yr+/ms4=";
  };
  buildInputs = [lutgen findutils coreutils];

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

  meta = with lib; {
    description = "Wallpaper collection from Weriomat";
    homepage = "https://github.com/weriomat/wallpapers";
    license = licenses.mit;
    maintainers = with maintainers; [weriomat];
    mainProgram = "wallpapers";
    platforms = platforms.all;
  };
}
