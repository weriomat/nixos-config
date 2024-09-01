{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "weriomat wallpapers";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "weriomat";
    repo = "wallpapers";
    rev = "2653162e282bdd876fa1a1b1c1881c2dcdbdbc2f";
    hash = "sha256-vbRXnm43PEu4r0624OTlBpOuSzepI2KrHRQnewT9VKY=";
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
