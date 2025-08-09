bg0="#2c2e34"
bg1="#33353f"
bg2="#363944"
bg3="#3b3e48"
bg4="#414550"
bg_blue="#354157"
bg_dim="#222327"
bg_green="#394634"
bg_red="#55393d"
bg_yellow="#4e432f"
black="#181819"
blue="#76cce0"
fg="#e2e2e3"
filled_blue="#85d3f2"
filled_green="#a7df78"
filled_red="#ff6077"
green="#9ed072"
grey="#7f8490"
grey_dim="#595f6f"
none="NONE"
orange="#f39660"
purple="#b39df3"
red="#fc5d7c"
yellow="#e7c664"

hex_to_rgb() {
    local hex=$1
    local hex=${hex#"#"}
    
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))

    echo "$r;$g;$b"
}

hex_to_rgba() {
    local hex=$1
    local hex=${hex#"#"}
    local alpha=${2:-ff}

    echo "0x$alpha$hex"
}

set_color() {
    local rgb=$(hex_to_rgb "$1")
    echo -ne "\033[38;2;${rgb}m"
}

reset_color() {
    echo -ne "\033[0m"
}

color_echo() {
    set_color $1
    echo $2
    reset_color
}
