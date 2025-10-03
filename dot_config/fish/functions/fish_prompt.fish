function fish_prompt
        set -l last_status $status
        set -l normal (set_color normal)
        set -l status_color (set_color brcyan)
        set -l cwd_color (set_color bryellow)
        set -l vcs_color (set_color brmagenta)
        set -l user_color (set_color white)
        set -l prompt_status ""
    
        set -q fish_prompt_pwd_dir_length
        or set -lx fish_prompt_pwd_dir_length 0
    
        set -l suffix '❯'
        if functions -q fish_is_root_user; and fish_is_root_user
                set cwd_color (set_color brred)
                set suffix '#'
        end
    
        if test $last_status -ne 0
                set status_color (set_color brred)
                set prompt_status (set_color white) "[" (set_color brred) $last_status (set_color white) "]" $normal
        end
    
        echo -s $user_color (prompt_login) $normal ' ' $cwd_color (prompt_pwd) $normal ' ' $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
        echo -n -s $status_color $suffix ' ' $normal
end
