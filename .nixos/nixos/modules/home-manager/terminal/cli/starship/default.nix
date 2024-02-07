{pkgs, ...}: {
  # TODO: rebuild this shit -> looks bad -> improve
  programs.starship = let
    flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
  in {
    enable = true;
    enableZshIntegration = true;
    settings =
      {
        palette = "catppuccin_mocha";
        add_newline = false;
        format = "$all";
        c.symbol = " ";
        lua.symbol = " ";
        nix_shell.symbol = " ";
        haskell.symbol = " ";
        os.symbols.NixOS = " ";
        python.symbol = " ";
        rust.symbol = " ";
        cmake.symbol = "$symbol";

        git_status.conflicted = "⚔️ ";
        git_status.ahead = "💨$count ";
        git_status.behind = "🐢$count ";
        git_status.diverged = "🔱 💨$ahead_count 🐢$behind_count ";
        git_status.untracked = "🛤️ $count";
        git_status.stashed = "📦 ";
        git_status.modified = "📝$count ";
        git_status.staged = "🗃️ $count ";
        git_status.renamed = "📛$count ";
        git_status.deleted = "🗑️ $count ";
        # git_status.ahead = "💨 ";
        # git_status.behind = "🐢 ";
        # git_status.diverged = "🔱 ";
        # git_status.untracked = "🛤️  ";
        # git_status.stashed = "📦 ";
        # git_status.modified = "📝 ";
        # git_status.staged = "🗃️  ";
        # git_status.renamed = "📛 ";
        # git_status.deleted = "🗑️  ";
        git_status.style = "bright-white";
        # git_status.format = "\\[ $all_status$ahead_behind\\]";
      }
      # // builtins.fromTOML
      # (builtins.readFile "${pkgs.starship-catppuccin}/themes/theme.toml");
      // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "starship";
          rev = "5629d23";
          # sha256 = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
          sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
        }
        + /palettes/${flavour}.toml));
  };
  # "${pkgs.packages.starship-catppuccin}/themes/theme.toml");
  # pkgs.additions.callPackage ./starship-catppuccin { }
  # "${pkgs.callPackagestarship-catppuccin.override { flavor = "mocca"; }}");
}
