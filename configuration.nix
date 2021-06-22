# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let 
   kmonad = import ./kmonad.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only


  networking.networkmanager.enable = true;
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      xwayland # for legacy apps
      alacritty
      kitty
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      rofi
      wofi
      waybar # status bar
      kanshi # autorandr
    ];
  };

  fonts.fonts = with pkgs; [
    #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    nerdfonts
    #fira-code-retina
    #fire-code-bold
    #fira-code-symbols
    pango
  ];


  environment.etc = {
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "sway/config".source = ./dotfiles/.config/i3/config;
      # "xdg/waybar/config".source = ./dotfiles/waybar/config;
      # "xdg/waybar/style.css".source = ./dotfiles/waybar/style.css;
      #"zsh/config".source = "./dotfiles/.zshrc";
      "zsh/zshrc".source = builtins.path{ name = "zshrc"; path = ./dotfiles/.zshrc;};
      "zshrc".source = builtins.path{ name = "zshrc"; path = ./dotfiles/.zshrc;};
      "xdg/kitty/kitty.conf".source = builtins.path{ name = "kitty.conf"; path = ./dotfiles/.config/kitty/kitty.conf;};
      "kmonad/neo_hybrid.kbd".source = builtins.path{ name = "neo_hybrid.kbd"; path = ./dotfiles/Dokumente/Programmieren/Projekte/other/kmonad/keymap/user/caplett/neo_hybrid.kbd;};
      #"zshrc".source = [ (builtins.readFile ./dotfiles/.zshrc) ];
  };



  programs.waybar.enable = true;


  systemd.user.services.kanshi = {
    enable = true;
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };


  systemd.user.targets.sway-session = {
    enable = true;
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

#  systemd.user.services.sway = {
#    enable = true;
#    description = "Sway - Wayland window manager";
#    documentation = [ "man:sway(5)" ];
#    bindsTo = [ "graphical-session.target" ];
#    wants = [ "graphical-session-pre.target" ];
#    after = [ "graphical-session-pre.target" ];
#    # We explicitly unset PATH here, as we want it to be set by
#    # systemctl --user import-environment in startsway
#    environment.PATH = lib.mkForce null;
#    serviceConfig = {
#      Type = "simple";
#      ExecStart = ''
#        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
#      '';
#      Restart = "on-failure";
#      RestartSec = 1;
#      TimeoutStopSec = 10;
#    };
#  };
    
  systemd.user.services.kmonad = {
    enable = true;
    description = "Autostart kmoand ";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      # Run kmoand on fixed config 
      ExecStart = ''
        /run/current-system/sw/bin/kmonad /etc/kmonad/neo_hybrid.kbd 
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };
   #

  services.xserver.displayManager.defaultSession = "sway";

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.stefan = {
     isNormalUser = true;
     home = "/home/stefan";
     extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput"]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
   };

  users.groups = { uinput = {}; };

  users.extraUsers.stefan = {
    extraGroups = ["input" "uinput" ];
  };


  services.udev.extraRules =
    ''
      # KMonad user access to /dev/uinput
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';


  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  programs.zsh.interactiveShellInit = ''
    # z - jump around
    # source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    #export ZSH_THEME="lambda"
    source $ZSH/oh-my-zsh.sh
  '';


  #programs.zsh.shellInit = ''
  #  if [ -n "${commands[fzf-share]}" ]; then
  #    source "$(fzf-share)/key-bindings.zsh"
  #    source "$(fzf-share)/completion.zsh"
  #  fi
  #'';
  
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    firefox
    htop
    keepassxc
    dropbox
    killall
    gparted
    ncdu
    tmux
    brightnessctl

    git
    fzf

    direnv
    kmonad
	
    oh-my-zsh

    anki
    #kmonad
    # Sway stuff. Move into single file later
    # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )

    (
      pkgs.writeTextFile {
        name = "togglebacklight";
        destination = "/bin/tooglebacklight";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/sh
          read lcd < /tmp/lcd
            if [ "$lcd" -eq "0" ]; then
                swaymsg "output * dpms on"
                echo 1 > /tmp/lcd
            else
                swaymsg "output * dpms off"
                echo 0 > /tmp/lcd
            fi
        '';
      }
    )
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

