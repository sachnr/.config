# envs
set -g fish_history_file ~/.local/share/fish/fish_history
set -gx EDITOR nvim
set -gx PYTHONPATH $HOME/.config/pip/site-packages
set -gx FZF_DEFAULT_OPTS "--layout=reverse"
set -g fish_greeting

# paths
fish_add_path $HOME/.npm/bin $HOME/.local/share/nvim/mason/bin
fish_add_path $HOME/.cargo/bin
fish_add_path (yarn global bin)
fish_add_path $HOME/.local/share/gem/ruby/3.2.0/bin
fish_add_path $HOME/go/bin

# Aliases
alias gg "lazygit"
alias gpush "git push"
alias gpr "git pull --rebase"
alias gdiff "nvim -c ':Git mergetool' -c ':Gdiff!'"
alias glog "git log --oneline --abbrev-commit --graph --all"
alias ls "eza --icons --group-directories-first"
alias la "eza -lah --icons --group-directories-first"
alias tree "eza --tree --icons --group-directories-first"
alias vi "nvim"
alias f "yazi"
alias tm "tmux-fzy"
alias top "btm -b"
alias gotest "gotestsum -f testname"
alias ca "chezmoi apply"

direnv hook fish | source
fish_vi_key_bindings
