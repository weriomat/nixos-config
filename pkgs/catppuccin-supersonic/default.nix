{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "catppuccin-supersonic";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "supersonic";
    rev = "3253427d55f23f2e731ab05a8ee14c613800b808";
    hash = "sha256-5U6NuDGvcYtJTKuseCuUS0orh9Yzlza7+zNMNVRolFM=";
  };

  skipUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    install -Dm444 themes/mocha/catppuccin-mocha-mauve.toml -t $out

    runHook postInstall
  '';

  meta = {
    description = "Catppuccin for Supersonic";
    homepage = "https://github.com/catppuccin/supersonic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.weriomat ];
    platforms = lib.platforms.linux;
  };
}
