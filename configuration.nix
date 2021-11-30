# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let 
  kmonad = import ./kmonad.nix;
  amd_gpu_patch = pkgs.callPackage ./amd_gpu_patch/default.nix {};
  amd_gpu_firmware = pkgs.callPackage ./amd_gpu_firmware/default.nix {};

  unstable = import
  (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
     # reuse the current configuration
     { config = config.nixpkgs.config; };

in {
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vim.nix
    ./utils.nix
    ./sway.nix
    #./i3.nix

    ./amd_gpu.nix
    (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")

      # Fish plug manager
      (fetchTarball "https://github.com/takagiy/nixos-declarative-fish-plugin-mgr/archive/0.0.5.tar.gz")
    ];


  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
#sound.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    config.pipewire = {
      "context.properties" = {
        #"link.max-buffers" = 64;
        "link.max-buffers" = 16; # version < 3 clients can't handle more than this
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;
      };
    };


  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
};

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
  boot.kernelParams = [ "i8042.reset" "i8042.nomux" "i8042.nopnp" "i8042.noloop" "xhci_hcd.quirks=1073741824" ];
  boot.initrd.availableKernelModules = [ "i8042 xhci_hcd" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" "i8042 xhci_hcd" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;

  services.mpd.enable = false;
  services.tlp.enable = true;


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
  #services.xserver.enable = false;

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
      "xdg/kitty/kitty.conf".source = builtins.path{ name = "kitty.conf"; path = ./config/kitty.conf;};
      "kmonad/neo_hybrid.kbd".source = builtins.path{ name = "neo_hybrid.kbd"; path = ./config/neo_hybrid.kbd;};
      "kmonad/neo_hybrid_ergodox.kbd".source = builtins.path{ name = "neo_hybrid_ergodox.kbd"; path = ./config/neo_hybrid_ergodox.kbd;};
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

    systemd.user.services.kmonad_ergodox = {
      enable = true;
      description = "Autostart kmoand ";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
      # Run kmoand on fixed config 
      ExecStart = ''
      /run/current-system/sw/bin/kmonad /etc/kmonad/neo_hybrid_ergodox.kbd 
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  services.udev.packages = [
    (
      pkgs.writeTextFile {
        name = "ergodox-kmonad udev rule";
        text = ''
        ACTION=="add", ATTRS{name}=="ZSA Technology Labs Inc Ergodox EZ Shine", TAG+="systemd", ENV{SYSTEMD_WANTS}="kmonad_ergodox.service"
        '';

        destination = "/etc/udev/rules.d/60-ergodox-kmonad.rules";
      }
      )
    ];


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    home = "/home/stefan";
    extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  home-manager.users.stefan = {
    programs.git = {
      enable = true;
      userName  = "Stefan Geyer";
      userEmail = "git@stefan-geyer.org";
    };


    programs.fzf = {
      enable = true;
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

home.file = {

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
};

  };

  programs.fish = {
    enable = true;
    plugins = [
      "lilyball/nix-env.fish"
      "jethrokuan/z"
    ];
  };


  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  users.groups = { uinput = {}; };

  services.udev.extraRules =
    ''
      # KMonad user access to /dev/uinput
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

      ACTION=="add", SUBSYSTEM=="backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"

      '';

      nixpkgs.config.allowUnfree = true;
  #services.nfs.server.enable = true;
  networking.firewall.extraCommands = ''
  ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "stefan" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

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
    unp
    unrar
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
    zathura
    vlc
    libreoffice
    pdftk
    conda

    slurp
    grim

    feh
    wdisplays
    sourcetrail
    nix-index
    lazygit
    mosh
    unstable.staruml
    unstable.pdfpc
    vagrant
    qbittorrent

    direnv
    kmonad
    steam
    protontricks

    slack
    zotero
    texlive.combined.scheme-full
    texlab

    mullvad-vpn
    openvpn

    dolphin

    (python3.withPackages(ps: [
      #ps.pyls-mypy 
      #ps.pyls-isort 
      ps.black
      #ps.jedi
      ps.numpy
    ]))


    pyright

    obsidian


    geckodriver
    light

    anki-bin
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

