function item_git_branch
    if not set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
        return
    end
    
    set_color '#A9DD76'

    if not set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
        set_color '#F79860'
        set branch (command git describe --contains --all HEAD 2>/dev/null)
    end

    if test -n "$branch"
        echo -n " $branch "
    end
end
