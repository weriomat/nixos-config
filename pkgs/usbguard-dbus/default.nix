# inspired by: https://github.com/max-baz/dotfiles/blob/77d345632ff6b5970612147db71da64361a6df3e/modules/linux/bin/waybar-usbguard
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule {
  name = "usbguard-dbus";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "weriomat";
    repo = "usbguard-dbus";
    rev = "533ffe1271894c94c13af0a0a1ed95c16f2d5ed7";
    hash = "sha256-UUt24EPTLg3qEe5pLwMk3DfLxyCltemvVV07jLFPVSc=";
  };

  vendorHash = null;

  meta = {
    description = "A helper for usbguard";
    homepage = "https://github.com/weriomat/usbguard-dbus";
    mainProgram = "usbguard-dbus";
    platforms = lib.platforms.all;
  };
}
