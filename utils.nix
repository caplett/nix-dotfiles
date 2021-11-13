
{ config, lib, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    (
      pkgs.writeTextFile {
        name = "togglebacklight";
        destination = "/bin/togglebacklight";
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
        (
          pkgs.writeTextFile {
            name = "tap_enable";
            destination = "/bin/tap_enable";
            executable = true;
            text = ''
          #! ${pkgs.bash}/bin/sh
          swaymsg input type:touchpad tap enable
          '';
        }   )
        (
          pkgs.writeTextFile {
            name = "tap_disable";
            destination = "/bin/tap_disable";
            executable = true;
            text = ''
          #! ${pkgs.bash}/bin/sh
          swaymsg input type:touchpad tap disable
          '';
        }

        )
      ];

    }
