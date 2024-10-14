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
    rev = "e97c5d06ea8e875634fdf3482951018444e781a2";
    hash = "sha256-ys1S/utfIvx0SoE+0sUDvvhD/5Bh96PYZTzq2efCNKo=";
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
