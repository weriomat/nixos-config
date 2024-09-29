{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "apple-emoji";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "samuelngs";
    repo = "apple-emoji-linux";
    rev = "e40e6d35657b908f473faed8f6461e8c54d01420";
    hash = "sha256-liklPjOJhHOBWQH8AQwkLfIG0KIqdnZcVAa7oMrVZMk=";
  };

  buildInputs = with pkgs; [optipng pngquant python312Packages.fonttools];
  runtimeInputs = with pkgs; [optipng];

  # TODO: here
  # installPhase = ''
  # '';

  description = "Apple Emoji for Linux";
}
