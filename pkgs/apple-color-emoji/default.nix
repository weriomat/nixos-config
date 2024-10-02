{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "apple-emoji";
  version = "0.0.1";

  # src = pkgs.fetchFromGitHub {
  #   owner = "samuelngs";
  #   repo = "apple-emoji-linux";
  #   rev = "e40e6d35657b908f473faed8f6461e8c54d01420";
  #   hash = "sha256-liklPjOJhHOBWQH8AQwkLfIG0KIqdnZcVAa7oMrVZMk=";
  # };
  src = pkgs.fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v17.4/AppleColorEmoji.ttf";
    hash = "sha256-SG3JQLybhY/fMX+XqmB/BKhQSBB0N1VRqa+H6laVUPE=";
  };

  # buildInputs = with pkgs; [optipng pngquant python312Packages.fonttools];
  # runtimeInputs = with pkgs; [optipng];

  # skipPhases = ["unpackPhase"];
  dontUnpack = true;
  # unpackPhase = ''
  # '';
  # TODO: here
  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truefont

    runHook postInstall
  '';

  description = "Apple Emoji for Linux";
}
# stdenv.mkDerivation rec {
#   pname = "apple-emoji-linux";
#   version = "17.4";
#   src = fetchFromGitHub {
#     owner = "samuelngs";
#     repo = "apple-emoji-linux";
#     rev = "v${version}";
#     hash = "sha256-liklPjOJhHOBWQH8AQwkLfIG0KIqdnZcVAa7oMrVZMk=";
#   };
#   meta = with lib; {
#     description = "Brings Apple's vibrant emojis to your Linux experience";
#     homepage = "https://github.com/samuelngs/apple-emoji-linux";
#     license = licenses.asl20;
#     maintainers = with maintainers; [ ];
#     mainProgram = "apple-emoji-linux";
#     platforms = platforms.all;
#     };

