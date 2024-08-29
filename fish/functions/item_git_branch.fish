function item_git_branch
    if not set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
        return
    end
    
    if set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
        set_color $palette_green
        echo -n " $branch "
    end

    if test -d (git rev-parse --git-dir 2>/dev/null)/rebase-merge -o -d (git rev-parse --git-dir 2>/dev/null)/rebase-apply
        set_color $palette_red
        echo -n " (rebase) "
    end
    if test -f (git rev-parse --git-dir 2>/dev/null)/MERGE_HEAD
        set_color $palette_red
        echo -n " (merge) "
    end
end
