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
    set -g -x EDITOR nvim
    set -g -x TERM xterm 

end

direnv hook fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/stefan/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set -gx  LD_LIBRARY_PATH /home/stefan/.mujoco/mujoco210/bin

