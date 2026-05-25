{
  lib,
  ...
}:
{
  steam.enable = true;

  # TODO: here
  borg.enable = lib.mkForce false;
  sops.enable = lib.mkForce false;

  # NOTE: disable virtualization
  virt.enable = lib.mkForce false;

  networking = {
    iwd.enable = false;
    networkd = {
      wlan.enable = false;
      lan.mac = "00:d8:61:d8:e8:7b";
    };

    hostId = "88f8e989";
  };

}
