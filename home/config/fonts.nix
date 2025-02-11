{
  inputs,
  pkgs,
  ...
}:
{
  fonts.fontconfig = {
    enable = true;
    # TODO: fonts -> fira code
    # NOTE: this config is for the hm user, we just configure it via nixos
    # defaultFonts = {
    #   serif = ["Source Serif"];
    #   sansSerif = ["FiraGO"];
    #   #   sansSerif = ["Fira Sans" "FiraGO" "Noto Color Emoji"];
    #   monospace = ["MonoLisa Nerd Font"];
    #   emoji = ["apple-emoji"];
    # };
  };

  # fonts:
  # https://fonts.google.com/noto/specimen/Noto+Emoji

  # NOTE: some fonts to keep in mind "IBMPlexMono" (nerfont), pkgs.twemoji-color-font, pkgs.iosevka-comfy.comfy
  home.packages = [
    inputs.monoLisa.packages.${pkgs.system}.default
    pkgs.apple-emoji

    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  gtk.font = {
    name = "JetBrainsMono Nerd Font";
    size = 11;
  };

  programs = {
    kitty = {
      font = {
        # NOTE: alternative "'BlexMono Nerd Font'"
        name = "MonoLisa Nerd Font";
        package = inputs.monoLisa.packages.${pkgs.system}.default;
        size = 16;
      };
      extraConfig = ''
        font_features MonoLisa -calt +liga +zero +ss01 +ss02 +ss07 +ss08 +ss10 +ss11 +ss18
        modify_font cell_width 100%
        modify_font cell_height 100%
        font_features MonoLisa-RegularItalic +ss02
      ''; # Stolen from https://github.com/redyf/nixdots/blob/main/home/desktop/addons/kitty/default.nix
      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
      };
    };
    # firefox.profiles.profileSettings.settings = {
    #   "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;
    #   "font.name.sans-serif.x-western" = config.stylix.fonts.sansSerif.name;
    #   "font.name.serif.x-western" = config.stylix.fonts.serif.name;
    # };
  };

  # services.mako.font = "Name size";
  # TODO: firefox, wofi, mako, swaylock, helix, wlogout

  # in normal nixos options
  # fonts.packages = [
  #   (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
  #   cm_unicode
  #   corefonts
  # ];

  # TODO: fonts
  # emoji = with pkgs; [ noto-fonts, noto-fonts-cjk, noto-fonts-emoji, noto-fonts-cjk-sans, noto-fonts-cjk-serif, noto-fonts-extra ];
  # nerd = with pkgs; [ carlito, ipafont, kochi-substitute, source-code-pro, ttf_bitstream_vera, (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" ]; }) ];

  # Configure fonts
  # fonts = {
  #   enableDefaultPackages = true;
  #   packages = with pkgs; [
  #     (nerdfonts.override {
  #       fonts = [
  #         "LiberationMono"
  #         "Terminus"
  #         "Ubuntu"
  #         "UbuntuMono"
  #         "UbuntuSans"
  #       ];
  #     })
  #     arphic-ukai
  #     arphic-uming
  #     gohufont
  #     noto-fonts
  #     noto-fonts-emoji
  #     noto-fonts-cjk
  #     # symbola
  #     terminus_font
  #     # ubuntu_font_family
  #     wqy_microhei
  #     wqy_zenhei
  #   ];
  #   fontconfig = {
  #     defaultFonts = {
  #       serif = [
  #         "Ubuntu Nerd Font"
  #         "Roboto"
  #         "Ubuntu"
  #       ];
  #       sansSerif = [
  #         "UbuntuSans Nerd Font"
  #         "Roboto"
  #         "Ubuntu"
  #       ];
  #       monospace = [
  #         "LiberationMono Nerd Font"
  #         "UbuntuMono Nerd Font"
  #         "BlexMono Nerd Font"
  #         "JetBrainsMono"
  #       ];
  #     };
  #   };

  #   enableDefaultPackages = true;
  #   packages = with pkgs; [
  #     # General stuff that supports most languages
  #     iosevka-comfy.comfy
  #     noto-fonts
  #     noto-fonts-cjk
  #     noto-fonts-emoji
  #     roboto
  #     ubuntu_font_family
  #     source-han-sans
  #     source-han-sans-japanese
  #     source-han-serif-japanese
  #     helvetica-neue-lt-std
  #     # Icon fonts
  #     font-awesome
  #     (nerdfonts.override {
  #       fonts = [
  #         "JetBrainsMono"
  #         "IBMPlexMono"
  #       ];
  #     })

  #     # Coding fonts
  #     powerline-fonts
  #     ibm-plex
  #     jetbrains-mono
  #   ];
  # TODO: fonots
  # Making fonts accessible to applications.
  # fonts.packages = with pkgs; [
  #   customFonts
  #   font-awesome
  #   myfonts.flags-world-color
  #   myfonts.icomoon-feather
  # ];
  #  customFonts = pkgs.nerdfonts.override {
  #   fonts = [
  #     "JetBrainsMono"
  #     "Iosevka"
  #   ];
  # }; # };
}
