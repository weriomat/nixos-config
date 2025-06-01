{
  inputs,
  globals,
  pkgs,
  ...
}:
{
  # TODO: set fallback, sync with nixos option, fix some fonts, let all apps use the default font?
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "FiraGO"
        #"Fira Sans"
        # "DejaVu Sans"
        #         "UbuntuSans Nerd Font"
        #         "Roboto"
        #         "Ubuntu"
      ];
      serif = [
        "DejaVu Serif"
        # "Source Serif"
        #         "Ubuntu Nerd Font"
        #         "Roboto"
        #         "Ubuntu"
      ];
      monospace = [
        "MonoLisa Nerd Font"
        # "JetBrainsMonoNL Nerd Font"
        # "DejaVu Sans Mono"
        # "FiraCode"
        #         "LiberationMono Nerd Font"
        #         "UbuntuMono Nerd Font"
        #         "BlexMono Nerd Font"
        #         "JetBrainsMono"
      ];
      emoji = [
        "Apple Color Emoji"
        # "Noto Color Emoji"
        # emoji = with pkgs; [ noto-fonts, noto-fonts-cjk, noto-fonts-emoji, noto-fonts-cjk-sans, noto-fonts-cjk-serif, noto-fonts-extra ];
      ];
    };
  };
  # nerd = with pkgs; [ carlito, ipafont, kochi-substitute, source-code-pro, ttf_bitstream_vera, (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" ]; }) ];

  waybar.font = "MonoLisa Nerd Font";
  # waybar.font = "JetBrainsMonoNL Nerd Font";
  hyprlock.font = "FiraMono Nerd Font";
  wofi.font = "MonoLisa Nerd Font, monospace";

  # TODO: fix this
  wlogout.font = "Fira Sans Semibold, FontAwesome, Roboto, Helvetica, Arial, sans-serif";

  # NOTE: some fonts to keep in mind "IBMPlexMono" (nerfont), pkgs.twemoji-color-font, pkgs.iosevka-comfy.comfy, "JetBrainsMono", "Iosevka", corefonts, "Ubuntu".nerd, "UbuntuMono".nerd, "UbuntuSans".nerd, terminus_font, iosevka-comfy.comfy, ubuntu_font_family, helvetica-neue-lt-std, "IBMPlexMono", ibm-plex
  home.packages = [
    inputs.monoLisa.packages.${pkgs.system}.default
    pkgs.apple-color-emoji
    pkgs.fira-go
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-mono
  ];

  gtk.font = {
    name = "MonoLisa Nerd Font";
    # name = "JetBrainsMono Nerd Font";
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
