{ config, pkgs, ... }:

let
  unstable = import
  (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
     # reuse the current configuration
     { config = config.nixpkgs.config; };
     overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
      }))
     ];
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "stefan";
  home.homeDirectory = "/home/stefan";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName  = "Stefan Geyer";
    userEmail = "git@stefan-geyer.org";
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
    # add_newline = false;

    # character = {
    #   success_symbol = "[➜](bold green)";
    #   error_symbol = "[➜](bold red)";
    # };

    # package.disabled = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    lazygit
    htop
    fish

    unstable.neovim
    wget
    htop
    pavucontrol
    ripgrep
    keepassxc
    gparted
    ncdu

    entr
    tmux
    brightnessctl

    git
    #fzf
    ranger
    tree
    mupdf
    qpdfview
    zathura
    vlc
    conda

    slurp
    grim

    feh
    lazygit
    mosh
    pdfpc

    direnv

    #slack
    #zotero
    #texlive.combined.scheme-full
    #texlab
    mullvad-vpn
    openvpn
    copyq
    silver-searcher
    fd
    ripgrep-all

    zotero

    glfw-wayland

    swaylock
    swayidle
    wl-clipboard
    mako # notification daemon
    alacritty # Alacritty is the default terminal in the config
    dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native

    swaybg
    mako # notification daemon
    rofi
    wofi

    gcc

    nerdfonts
    font-awesome
    pango
  ];

  home.file = {
    ".config/nvim" = {
      source = ./config/vim;
      recursive = true;
    };

    ".config/fish" = {
      source = ./config/fish;
      recursive = true;
    };

    ".config/lazygit/config.yml" = {
      source = ./config/lazygit/config.yml;
    };

    ".vim/privat_snippets" = {
      source = ./config/vim/ultisnips;
      recursive = true;
    };

    ".config/kanshi/config" = {
      source = ./config/kanshi/config;
    };

    ".config/kitty/kitty.conf".source = builtins.path{ name = "kitty.conf"; path = ./config/kitty.conf;};

    ".config/kmonad/neo_hybrid.kbd".source = builtins.path{ name = "neo_hybrid.kbd"; path = ./config/neo_hybrid.kbd;};

    ".config/kmonad/neo_hybrid_ergodox.kbd".source = builtins.path{ name = "neo_hybrid_ergodox.kbd"; path = ./config/neo_hybrid_ergodox.kbd;};

    ".tmux.conf".source = builtins.path{ name = "tmux.conf"; path = ./config/tmux.conf;};


    ".config/sway/config".source = ./config/i3_config;

    ".direnvrc".source = ./config/direnvrc;


    ".config/waybar/config".source = ./config/waybar/config;
    ".config/waybar/style.css".source = ./config/waybar/style.css;

    ".config/foot/foot.ini".source = ./config/foot.ini;

    ".ssh/config".source = ./config/ssh_config;

  };

}
