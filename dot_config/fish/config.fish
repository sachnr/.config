# envs
set -g fish_history_file ~/.local/share/fish/fish_history
set -gx EDITOR nvim
set -gx PYTHONPATH $HOME/.config/pip/site-packages $PYTHONPATH
set -gx FZF_DEFAULT_OPTS "--layout=reverse"
set -g fish_greeting
xset r rate 250 50

# paths
fish_add_path $HOME/.npm/bin $HOME/.local/share/nvim/mason/bin
fish_add_path $HOME/.cargo/bin
fish_add_path (yarn global bin)
fish_add_path $HOME/go/bin
fish_add_path $HOME/.local/bin

# Aliases
alias gg "lazygit"
alias gpush "git push"
alias gpr "git pull --rebase"
alias gdiff "nvim -c ':Git mergetool' -c ':Gdiff!'"
alias glog "git log --oneline --abbrev-commit --graph --all"
alias ls "eza --icons --group-directories-first"
alias la "eza -lah --icons --group-directories-first"
alias tree "eza --tree --icons --group-directories-first"
alias find "fd"
alias cat "bat"
alias vi "nvim"
alias vim "nvim"
alias f "yazi"
alias top "btm -b"
alias gotest "gotestsum -f testname"
alias ca "chezmoi apply"
alias python "python3.12"

direnv hook fish | source
fish_vi_key_bindings
bind --mode default \cf _fzf_search_directory
bind --mode insert \cf _fzf_search_directory
bind --mode default \cr _fzf_search_history   
bind --mode insert \cr _fzf_search_history   

function tm
    set -l cache_file ~/.cache/.tmux-fzy
    
    for line in (cat $cache_file)
        set -l parts (string split ':|:' $line)
        set -l path $parts[1]
        set -l mindepth $parts[2]
        set -l maxdepth $parts[3]
        
        if test -d $path
            if test $mindepth -eq 0 -a $maxdepth -eq 0
                echo $path
            else
                fd -H -t d --min-depth $mindepth --max-depth $maxdepth . $path
            end
        end
    end | fzf --prompt="Select directory: " | read -l selected
    
    if test -n "$selected" -a -d "$selected"
        cd "$selected"
        echo "Changed to: $selected"
    end
end

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/sachnr/.opam/opam-init/init.fish' && source '/home/sachnr/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
