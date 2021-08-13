
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
        name = "screensnip";
        destination = "/bin/screensnip";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/sh
	  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | wl-copy
        '';
      }

    )

  ];

}
