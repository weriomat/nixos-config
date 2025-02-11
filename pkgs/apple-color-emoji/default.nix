{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  imagemagick,
  pngquant,
  zopfli,
  python312Packages,
  ...
}:
stdenv.mkDerivation {
  pname = "apple-emoji";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "samuelngs";
    repo = "apple-emoji-linux";
    rev = "e40e6d35657b908f473faed8f6461e8c54d01420";
    hash = "sha256-liklPjOJhHOBWQH8AQwkLfIG0KIqdnZcVAa7oMrVZMk=";
  };

  buildInputs = [
    which
    imagemagick
    pngquant
    zopfli
    python312Packages.fonttools
    python312Packages.nototools
  ];

  buildPhase = ''
    make -j
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truefont
    install -Dm644 AppleColorEmoji.ttf -t $out/share/fonts/truefont

    runHook postInstall
  '';

  meta = {
    description = "Brings Apple's vibrant emojis to your Linux experience";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.weriomat ];
    mainProgram = "apple-emoji-linux";
    platforms = lib.platforms.all;
  };
}
