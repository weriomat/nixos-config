{
  pkgs,
  globals,
  ...
}: {
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
        right_format =
          if globals.laptop
          then ''
            $cmd_duration$hostname$memory_usage$jobs$status$os$container$battery$time
          ''
          else ''
            $cmd_duration$hostname$memory_usage$jobs$status$os$container$time
          '';

        cmd_duration =
          if globals.laptop
          then {
            min_time = 500;
            format = "[$duration ](italic bright-yellow)";
          }
          else {};

        time = {
          disabled = false;
          format = "[ $time]($style)";
          time_format = "%R";
          utc_time_offset = "local";
          style = "dimmed white";
        };

        battery =
          if globals.laptop
          then {
            format = "[ $percentage $symbol]($style)";
            full_symbol = "[█](italic green)";
            charging_symbol = "[↑](italic green)";
            discharging_symbol = "[↓](italic)";
            unknown_symbol = "[░](italic)";
            empty_symbol = "[▃](italic red)";
            display = [
              {
                threshold = 40;
                style = "dimmed yellow";
              }
              {
                threshold = 70;
                style = "dimmed white";
              }
            ];
          }
          else {};

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
