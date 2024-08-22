function item_status
    if test $cmd_status -ne 0
        set_color $palette_red
        echo -n "✘ $cmd_status "
    end
end
