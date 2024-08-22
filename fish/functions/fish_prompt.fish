function fish_prompt
    set -g cmd_status $status

    echo -n (set_color '#E7C664')(prompt_pwd)' '
    echo -n (set_color '#FC5D7C')'❯ '

    set_color normal
end
