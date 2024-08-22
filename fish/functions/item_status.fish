function item_status
    if test $cmd_status -ne 0
        set_color "#FF6077"
        echo -n "✘ $cmd_status "
    end
end
