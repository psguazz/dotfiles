function item_status
    set -l cmd_status $status
    if test $cmd_status -ne 0
        set_color "#FF6077"
        echo -n "✘ $cmd_status "
    end
end
