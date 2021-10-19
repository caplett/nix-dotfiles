if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

    if command --search starship > /dev/null
        starship init fish | source
    end

    if command --search direnv > /dev/null
        eval (direnv hook fish)
    end

end
