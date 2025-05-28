{
  stdenv,
  fetchurl,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  pname = "apple-color-emoji";
  version = "18.4";
  src = fetchurl {
    name = "${pname}-${version}";
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v${version}/AppleColorEmoji.ttf";
    sha256 = "sha256-pP0He9EUN7SUDYzwj0CE4e39SuNZ+SVz7FdmUviF6r0=";
  };

  unpackPhase = ''
    runHook preUnpack

    cp $src AppleColorEmoji.ttf

    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truefont
    install -Dm444 AppleColorEmoji.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Brings Apple's vibrant emojis to your Linux experience";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.weriomat ];
    platforms = lib.platforms.all;
  };
}
