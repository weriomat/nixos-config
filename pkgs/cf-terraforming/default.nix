{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cf-terraforming";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf-terraforming";
    rev = "v${version}";
    hash = "sha256-iv4vQRQNYBl2v2TAK11VJbVCQB1jw51NjGJ80aIGPbQ=";
  };

  vendorHash = "sha256-zREJA2BgAYQWOXxAV40xmcQe9YW9Cm+VaTxj/khe5ks=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=${version}"
  ];

  doCheck = false;

  meta = {
    description = "A command line utility to facilitate terraforming your existing Cloudflare resources";
    homepage = "https://github.com/cloudflare/cf-terraforming";
    changelog = "https://github.com/cloudflare/cf-terraforming/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cf-terraforming";
  };
}
