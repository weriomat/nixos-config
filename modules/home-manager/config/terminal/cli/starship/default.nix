{pkgs, ...}: {
  # TODO: rebuild this shit -> looks bad -> improve
  # NOTE: does not support nix-colors
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

        git_status = {
          conflicted = "⚔️ ";
          ahead = "💨$count ";
          behind = "🐢$count ";
          diverged = "🔱 💨$ahead_count 🐢$behind_count ";
          untracked = "🛤️ $count";
          stashed = "📦 ";
          modified = "📝$count ";
          staged = "🗃️ $count ";
          renamed = "📛$count ";
          deleted = "🗑️ $count ";
          # ahead = "💨 ";
          # behind = "🐢 ";
          # diverged = "🔱 ";
          # untracked = "🛤️  ";
          # stashed = "📦 ";
          # modified = "📝 ";
          # staged = "🗃️  ";
          # renamed = "📛 ";
          # deleted = "🗑️  ";
          style = "bright-white";
          # format = "\\[ $all_status$ahead_behind\\]";
        };
      }
      // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "starship";
          rev = "5629d23";
          sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
        }
        + /palettes/${flavour}.toml));
  };
}
