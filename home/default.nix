{ ... }:
{
  imports = [
    ./config
  ];
}
# TODO: automatic imports of things
# imports = with builtins;
#     map (fn: ./${fn})
#       (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
# TODO: qt
# https://github.com/niksingh710/ndots/blob/master/home/optional/qt.nix
