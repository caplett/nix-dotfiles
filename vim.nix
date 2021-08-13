{ config, lib, pkgs, ... }:
{


  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.configure.customRC = (builtins.readFile ./config/vimrc);


  environment.systemPackages = with pkgs; [
    vim 

    (
      pkgs.writeTextFile {
        name = "syncvimwiki";
        destination = "/bin/syncvimwiki";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/sh
          cd /home/stefan/vimwiki
          while sleep 1 ; do /run/current-system/sw/bin/find . | /run/current-system/sw/bin/entr -n -d /bin/sh -c "/run/current-system/sw/bin/git add -A && /run/current-system/sw/bin/git commit -m 'Update vimwiki' && /run/current-system/sw/bin/git pull && /run/current-system/sw/bin/git push" ; done
        '';
      }

    )
  ];

  systemd.user.services.clone_vimwiki = {
    enable = true;
    description = "Clone vimwiki repo if not present";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      # Minus before command signals that failure are ignored.
      ExecStart = ''
        -${pkgs.git}/bin/git clone git@git.caplett.com:jadas/zettelkasten.git /home/stefan/vimwiki -q
      '';
    };
  };


  systemd.user.services.syncvimwiki = {
    enable = true;
    description = "automatic push and pull on save in vimwiki";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      # Minus before command signals that failure are ignored.
      ExecStart = ''
       /run/current-system/sw/bin/syncvimwiki 
      '';
      Restart = "always";
    };
  };


}
