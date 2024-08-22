function item_cmd_duration
    if not test $CMD_DURATION -gt 1000
        return
    end
    
    set h (math -s0 $CMD_DURATION/3600000)
    set m (math -s0 $CMD_DURATION/60000 % 60)
    set s (math -s0 $CMD_DURATION/1000 % 60) 

    set_color $palette_orange
    echo -n "󰔟 "
    
    if test $h != "0"
        echo -n "$h"
        echo -n "h" 
    end

    if test $m != "0"
        echo -n "$m"
        echo -n "m" 
    end

    echo -n "$s"
    echo -n "s " 
end

