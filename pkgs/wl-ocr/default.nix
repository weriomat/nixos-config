{
  # FROM https://github.com/niksingh710/ndots/blob/master/pkgs/wl-ocr/default.nix
  writeShellApplication,
  lib,
  grim,
  libnotify,
  slurp,
  tesseract5,
  wl-clipboard,
  langs ? "eng+hun+fra+jpn+jpn_vert+kor+kor_vert+pol+ron+spa+hin+deu+deu_frak",
}:
# Taken from <https://github.com/fufexan/dotfiles/tree/main/pkgs/wl-ocr/default.nix>

writeShellApplication {
  name = "wl-ocr";
  text = # sh
    ''
      ${lib.getExe grim} -g "$(${lib.getExe slurp})" -t ppm - \
      | ${lib.getExe tesseract5} -l ${langs} - - \
      | ${lib.getExe' wl-clipboard "wl-copy"}

      ${lib.getExe' wl-clipboard "wl-paste"}

      ${lib.getExe libnotify} -- "Copied Content:" "$(${lib.getExe' wl-clipboard "wl-paste"})"
    '';
}
