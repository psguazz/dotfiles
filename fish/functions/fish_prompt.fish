function fish_prompt
    set -g cmd_status $status

    load_palette

    echo -n (set_color $palette_yellow)(prompt_pwd)" "
    echo -n (set_color $palette_red)"❯ "

    set_color normal
end
