{
  inputs,
  globals,
  pkgs,
  ...
}:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "FiraGO"
        "Fira Sans"
        "Iosevka Nerd Font"
      ];
      serif = [
        "DejaVu Serif"
        "Roboto Serif"
      ];
      monospace = [
        "MonoLisa Nerd Font"
        "JetBrainsMonoNL Nerd Font"
        "BlexMono Nerd Font Mono"
      ];
      emoji = [
        "Apple Color Emoji"
        "Noto Color Emoji"
      ];
    };
  };

  waybar.font = "MonoLisa Nerd Font"; # alternative "JetBrainsMonoNL Nerd Font"
  hyprlock.font = "FiraMono Nerd Font";
  wofi.font = "MonoLisa Nerd Font, monospace";

  wlogout.font = "Fira Sans Semibold, monospace";

  # NOTE: some fonts to keep in mind "IBMPlexMono" (nerfont), pkgs.twemoji-color-font, pkgs.iosevka-comfy.comfy, "JetBrainsMono", "Iosevka", corefonts, "Ubuntu".nerd, "UbuntuMono".nerd, "UbuntuSans".nerd, terminus_font, iosevka-comfy.comfy, ubuntu_font_family, helvetica-neue-lt-std, "IBMPlexMono", ibm-plex
  home.packages = [
    inputs.monoLisa.packages.${pkgs.system}.default
    pkgs.apple-color-emoji
    pkgs.fira
    pkgs.fira-go
    pkgs.roboto-serif
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.blex-mono
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-mono
    pkgs.noto-fonts-emoji
  ];

  gtk.font = {
    name = "MonoLisa Nerd Font"; # alternative "JetBrainsMono Nerd Font"
    size = 11;
  };

  services.mako.settings.font = "FiraGO"; # "JetBrainsMono Nerd Font 12";
  programs = {
    # NOTE: font.name.<kind>.x-western is set to default set by fontconfig, so dont touch
    # Test browser emoji via https://unicode.org/emoji/charts/full-emoji-list.html
    firefox.profiles.${globals.username}.settings.font.name-list.emoji =
      "Apple Color Emoji, Twemoji Mozilla";
    kitty = {
      # NOTE: alternative "'BlexMono Nerd Font'"
      extraConfig = ''
        font_features MonoLisa -calt +liga +zero +ss01 +ss02 +ss07 +ss08 +ss10 +ss11 +ss18
        font_features MonoLisa-Medium +zero +ss04 +ss07 +ss08 +ss09
        font_features MonoLisa-MediumItalic +zero +ss04 +ss07 +ss08 +ss09
        # Enable Script feature specifically
        font_features MonoLisa-RegularItalic +ss02

        # another way
        font_family family="MonoLisa"
        bold_font auto
        italic_font auto
        bold_italic_font auto
        font_size 16
      ''; # Stolen from https://github.com/redyf/nixdots/blob/main/home/desktop/addons/kitty/default.nix
    };
  };
}
