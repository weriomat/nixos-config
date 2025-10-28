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
    rev = "3d8332b0c203025ea84e8e057e2a062c163db5d7";
    hash = "sha256-CC4HV1clRPz3ljetm+Oaz1Sc+F2OXxgHlunKBGv4Q0U=";
  };

  vendorHash = null;

  meta = {
    description = "A helper for usbguard";
    homepage = "https://github.com/weriomat/usbguard-dbus";
    mainProgram = "usbguard-dbus";
    platforms = lib.platforms.all;
  };
}
