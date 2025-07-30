status --is-interactive; and source (rbenv init -|psub)
source ~/.config/fish/functions/load_palette.fish

load_palette

if status --is-interactive
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	eval /opt/homebrew/bin/conda "shell.fish" "hook" $argv | source
	# <<< conda initialize <<<
end

export FZF_DEFAULT_OPTS="
	--color=bg+:$palette_bg1,bg:$palette_bg_dim,spinner:$palette_purple,hl:$palette_blue
	--color=fg:$palette_fg,header:$palette_orange,info:$palette_grey,pointer:$palette_bg_red
	--color=marker:$palette_bg_green,fg+:$palette_fg,prompt:$palette_yellow,hl+:$palette_bg_green
	--color=gutter:$palette_bg_dim
"

set -x PATH $PATH $HOME/go/bin

direnv hook fish | source
