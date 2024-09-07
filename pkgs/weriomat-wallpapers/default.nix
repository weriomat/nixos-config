{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "weriomat wallpapers";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "weriomat";
    repo = "wallpapers";
    rev = "b2744db6bd7f509d0c839ebb90f30cc2fc784126";
    hash = "sha256-dD83T0M2v2L3IQqmwmqiZe52sgUqhNFLZIiqE40v2Vg=";
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
