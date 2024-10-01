{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "weriomat wallpapers";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "weriomat";
    repo = "wallpapers";
    rev = "e97c5d06ea8e875634fdf3482951018444e781a2";
    hash = "sha256-VJ0ZOn2I3bxdWabn9KAbL5AmkZUz9AuhbaXQXgEGm3Q=";
  };

  buildInputs = with pkgs; [lutgen findutils coreutils];

  buildPhase = ''
    mkdir -p $out/lut_wallpapers
    find . -type f -exec ${pkgs.lutgen}/bin/lutgen apply {} -p catppuccin-mocha -o $out/lut_wallpapers/{} \;
  '';

  installPhase = ''
    runHook preInstall

    mv $out/lut_wallpapers/* $out
    rm -r $out/lut_wallpapers

    runHook postInstall
  '';

  description = "Wallpaper collection from Weriomat";
}
