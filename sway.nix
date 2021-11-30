{ config, lib, pkgs, ... }:
{


  environment.etc = {
      "sway/config".source = ./config/i3_config;
       "xdg/waybar/config".source = ./config/waybar/config;
       "xdg/waybar/style.css".source = ./config/waybar/style.css;
  };

  services.xserver.displayManager.defaultSession = "none";

  environment.systemPackages = with pkgs; [
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
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaybg
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

  xdg.portal.enable = true;
  
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

  
  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

}
