_: {
  programs.tealdeer = {
    enable = true; # tldr written in rust
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 168;
      };
    };
  };
}
