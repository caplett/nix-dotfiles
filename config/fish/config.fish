if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

    if command --search starship > /dev/null
        starship init fish | source
    end

    if command --search direnv > /dev/null
        eval (direnv hook fish)
    end

    set PATH $PATH /home/stefan/.nix-profile/bin
    set PATH $PATH /nix/var/nix/profiles/default/bin
    set PATH $PATH /home/stefan/.cargo/bin
    set PATH $PATH /home/stefan/.local/bin
    set HYDRA_FULL_ERROR 1
    set -g -x EDITOR nvim
    set -g -x TERM xterm 
    set -g -x FZF_ALT_C_COMMAND '/home/stefan/.nix-profile/bin/fd --type d'

end

direnv hook fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/stefan/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set -gx  LD_LIBRARY_PATH /home/stefan/.mujoco/mujoco210/bin

set -U ZO_CMD zo
set -U Z_CMD z
set -U Z_DATA /home/stefan/.local/share/z/data
set -U Z_DATA_DIR /home/stefan/.local/share/z
set -U Z_EXCLUDE '^/home/stefan$'
set -U __fish_initialized 3100

set -U _fish_abbr_s sudo -E

set -U _fish_abbr_sv sudo -E nvim
#set -U _fish_abbr_v LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 nvim
set -U _fish_abbr_v /usr/bin/nvim.appimage

set -U _fish_abbr_sgl sudo -E lazygit
set -U _fish_abbr_gl lazygit

set -U _fish_abbr_gs git status
set -U _fish_abbr_g git
set -U _fish_abbr_r ranger
set -U _fish_abbr_kl 'ps -A | /home/stefan/.fzf/bin/fzf | grep -Eoh \"[^:][0-9]{2,6}[^:]\" | xargs kill'
set -U _fish_abbr_h htop
set -U _fish_abbr_p 'ping 1.1'
set -U _fish_abbr_pdf sioyek      

set -U _fish_abbr_cdn cd /etc/nixos
set -U _fish_abbr_cdnc cd /etc/nixos/config


set -U _fish_abbr_cdmcd cd /home/stefan/master_arbeit/Code/dreamer-pytorch

#set -U _fish_abbr_tap-enable swaymsg input type:touchpad tap enable
#set -U _fish_abbr_tap-disable swaymsg input type:touchpad tap disable

set -U _fish_abbr_nr 'NIXPKGS_ALLOW_UNFREE=1 nix run -f channel:nixos-21.05'
set -U _fish_abbr_l ls
set -U _fish_abbr_ssf 'grim -g (slurp)'
set -U _fish_abbr_ss 'grim -g (slurp) - | xclip -i -selection clipboard -t image/png'
set -U --export nixos_fish_plugins_installed yes
set -U fish_user_paths /home/stefan/.fzf/bin
