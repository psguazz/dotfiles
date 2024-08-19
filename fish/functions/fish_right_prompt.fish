function fish_right_prompt
    set -l cmd_status $status
    if test $cmd_status -ne 0
        echo -n (set_color red)"✘ $cmd_status"
    end

    if set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
        # Get the current action ("merge", "rebase", etc.)
        # and if there's one get the current commit hash too.
        set -l commit ''
        if set -l action (fish_print_git_action "$git_dir")
            set commit (command git rev-parse HEAD 2> /dev/null | string sub -l 7)
        end

        # Get either the branch name or a branch descriptor.
        set -l branch_detached 0
        if not set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
            set branch_detached 1
            set branch (command git describe --contains --all HEAD 2>/dev/null)
        end

        set_color -o

        if test -n "$branch"
            if test $branch_detached -ne 0
                set_color '#F79860'
            else
                set_color '#A9DD76'
            end
            echo -n " $branch  "
        end
    end

    set_color '#5A5E7A'
    echo -n (date +%H:%M)
    echo -n " "

    set_color normal
end
