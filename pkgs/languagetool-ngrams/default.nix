{
  stdenv,
  lib,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "languagetool-ngram-ende";
  version_en = "20150817";
  version_de = "20150819";
  version = "0.0.1";

  srcs = [
    (fetchzip {
      name = "en";
      url = "https://languagetool.org/download/ngram-data/ngrams-en-${version_en}.zip";
      sha256 = "v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
    })
    (fetchzip {
      name = "de";
      url = "https://languagetool.org/download/ngram-data/ngrams-de-${version_de}.zip";
      sha256 = "b+dPqDhXZQpVOGwDJOO4bFTQ15hhOSG6WPCx8RApfNg=";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/languagetool/ngrams
    for _src in $srcs; do
        ln -s "$_src" $out/share/languagetool/ngrams/$(stripHash "$_src")
    done

    runHook postInstall
  '';

  meta = {
    description = "LanguageTool can make use of large n-gram data sets to detect errors with words that are often confused, like their and there.";
    homepage = "https://dev.languagetool.org/finding-errors-using-n-gram-data.html";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.weriomat ];
    platforms = lib.platforms.linux;
  };
}
