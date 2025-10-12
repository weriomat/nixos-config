{
  config,
  lib,
  globals,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.firefox;
in
{
  config = mkIf cfg.enable {
    programs.firefox.profiles.${globals.username}.bookmarks = {
      force = true;
      settings = [
        {
          name = "kernel history";
          tags = [ "kernel" ];
          url = "https://elixir.bootlin.com/linux/";
        }
        {
          name = "Postmarket OS";
          url = "https://wiki.postmarketos.org/wiki/Main_Page";
        }
        {
          name = "Home-Manager Wiki";
          tags = [ "wiki" ];
          keyword = "homemanager";
          url = "https://nix-community.github.io/home-manager/options.xhtml";
        }
        {
          name = "Nix - A One Pager -> Nix Language";
          tags = [ "wiki" ];
          keyword = "nix";
          url = "https://github.com/tazjin/nix-1p";
        }
        {
          name = "nixos-manual";
          tags = [ "wiki" ];
          keyword = "nixos";
          url = "https://nixos.org/manual/nix/stable/introduction";
        }
        {
          name = "NixOS - Book";
          tags = [ "Books" ];
          keyword = "nixbook";
          url = "https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration";
        }
        {
          name = "Install guide of steam";
          tags = [ "wiki" ];
          keyword = "steam";
          url = "https://jmglov.net/blog/2022-06-20-installing-steam-on-nixos.html";
        }
        {
          name = "rust flake";
          tags = [ "rust" ];
          url = "https://www.tweag.io/blog/2022-09-22-rust-nix/";
        }
        {
          name = "rust flake with hercules ci";
          tags = [ "rust" ];
          url = "https://github.com/cpu/rust-flake/blob/main/README.md";
        }
        {
          name = "noogle";
          toolbar = true;
          bookmarks = [
            {
              name = "noogle";
              tags = [ "nix" ];
              url = "https://noogle.dev/";
            }
          ];
        }
        {
          name = "Utils";
          toolbar = true;
          bookmarks = [
            {
              name = "Chmod calc";
              url = "https://chmod-calculator.com/";
            }
            {
              name = "Nixhub";
              url = "https://www.nixhub.io/";
            }
            {
              name = "gpg cheat-sheet";
              url = "https://gock.net/blog/2020/gpg-cheat-sheet";
            }
          ];
        }
        {
          name = "Grafana - Dashboard";
          toolbar = true;
          bookmarks = [
            {
              name = "dashboard raspi doc";
              url = "https://github.com/rfmoz/grafana-dashboards";
            }
          ];
        }
        {
          name = "Rust";
          toolbar = true;
          bookmarks = [
            {
              name = "rust programming lang book";
              url = "https://doc.rust-lang.org/stable/book/";
            }
          ];
        }
        {
          name = "Category Theory";
          toolbar = true;
          bookmarks = [
            {
              name = "Stanford summary";
              url = "https://plato.stanford.edu/entries/category-theory/";
            }
            {
              name = "auburn summary";
              url = "https://web.auburn.edu/holmerr/8970/Textbook/CategoryTheory.pdf";
            }
            {
              name = "ucsb script";
              url = "https://web.math.ucsb.edu/~atrisal/category%20theory.pdf";
            }
            {
              name = "Standford book recommendations";
              url = "https://plato.stanford.edu/entries/category-theory/bib.html";
            }
          ];
        }
      ];
    };
  };
}
