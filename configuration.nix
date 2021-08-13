# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let 
   kmonad = import ./kmonad.nix;
   amd_gpu_patch = pkgs.callPackage ./amd_gpu_patch/default.nix {};
   amd_gpu_firmware = pkgs.callPackage ./amd_gpu_firmware/default.nix {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vim.nix
      ./utils.nix
      ./sway.nix
      ./amd_gpu.nix
	
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_5_9;
  boot.kernelParams = [ "i8042.reset i8042.nomux i8042.nopnp i8042.noloop xhci_hcd.quirks=1073741824" ];
  boot.initrd.availableKernelModules = [ "i8042 xhci_hcd" ];
  boot.kernelModules = [ "i8042 xhci_hcd" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;

  services.mpd.enable = false;


  networking.networkmanager.enable = true;
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall.checkReversePath = "loose";
  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;


  fonts.fonts = with pkgs; [
    nerdfonts
    font-awesome
    pango
  ];


  environment.etc = {
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "zsh/zshrc".source = builtins.path{ name = "zshrc"; path = ./dotfiles/.zshrc;};
      "zshrc".source = builtins.path{ name = "zshrc"; path = ./dotfiles/.zshrc;};
  };


  };


      "xdg/kitty/kitty.conf".source = builtins.path{ name = "kitty.conf"; path = ./config/kitty.conf;};
      "kmonad/neo_hybrid.kbd".source = builtins.path{ name = "neo_hybrid.kbd"; path = ./config/neo_hybrid.kbd;};
      "tmux.conf".source = builtins.path{ name = "tmux.conf"; path = ./config/tmux.conf;};
  };

    
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
  services.xserver.libinput.touchpad.disableWhileTyping = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.stefan = {
     isNormalUser = true;
     home = "/home/stefan";
     extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput" "docker"]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
   };

   home-manager.users.stefan = {
     programs.git = {
       enable = true;
       userName  = "Stefan Geyer";
       userEmail = "git@stefan-geyer.org";
     };


   programs.zsh = {
     enable = true;
     autocd = true;
     enableAutosuggestions = true;
     enableCompletion = true;
     initExtraFirst = (builtins.readFile ./config/zshrc);
   };


  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
  };
 
   programs.zsh = {
	   enable = true;
	   enableCompletion = true;
	   autosuggestions.enable = true;
	   syntaxHighlighting.enable = true;
           shellInit = ''
		   eval "$(starship init zsh)"
		   '';
   };

  virtualisation.docker.enable = true;

  users.groups = { uinput = {}; };

  services.udev.extraRules =
    ''
      # KMonad user access to /dev/uinput
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

      ACTION=="add", SUBSYSTEM=="backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
      
    '';

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    firefox
    htop
    pavucontrol
    ripgrep
    keepassxc
    dropbox
    killall
    gparted
    parted
    ncdu
    unzip
    entr
    gcc
    ccache
    tmux
    brightnessctl

    git
    wev
    fzf
    ranger
    tree
    mupdf
    qpdfview
    libreoffice
    pdftk
    conda

    feh

    direnv
    kmonad
    steam
    protontricks
    mullvad-vpn
	
    dolphin

    (python3.withPackages(ps: [
      ps.python-language-server
      ps.pyls-mypy ps.pyls-isort ps.pyls-black
      ps.jedi
      ps.numpy
      ]))
   

    pyright


    geckodriver
    light

    anki
    neuron-notes
    ag
    fd
    amd_gpu_patch
    amd_gpu_firmware
  ];



virtualisation.oci-containers.backend= "docker";



  programs.steam.enable = true;

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
  programs.ssh.startAgent = true;

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

