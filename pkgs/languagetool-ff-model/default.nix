{
  stdenv,
  fetchurl,
  lib,
  ...
}:
stdenv.mkDerivation {
  pname = "languagetool-ff-model";
  version = "0.0.1";

  src = fetchurl {
    url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
    sha256 = "fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
  };

  unpackPhase = ''
    runHook preUnpack

    cp $src lid.176.bin

    runHook postUnpack
  '';

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/languagetool/fasttextmodel/
    install -Dm444 lid.176.bin -t $out/share/languagetool/fasttextmodel

    runHook postInstall
  '';

  meta = {
    description = "LanguageTool can make use of large n-gram data sets to detect errors with words that are often confused, like their and there.";
    homepage = "https://dev.languagetool.org/finding-errors-using-n-gram-data.html";
    license = lib.licenses.cc-by-sa-30;
    maintainers = [ lib.maintainers.weriomat ];
    platforms = lib.platforms.linux;
  };

}
