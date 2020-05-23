#!/bin/sh

SESSION="dotfiles"
SESSION_AVAILABLE=$(tmux list-sessions | grep $SESSION)

if test -z "$SESSION_AVAILABLE"; then
	tmux -f "${TMUX_CONFIG_HOME}/tmux.conf" new-session -d -s $SESSION -n \
	vim -x $(tput cols) -y $(tput lines)

	tmux send-keys -t $SESSION:vim "cd ${CONFIG_HOME}" Enter
	tmux send-keys -t $SESSION:vim.bottom "clear" Enter
	tmux send-keys -t $SESSION:vim "vim -c Files" Enter
	tmux split-window -t $SESSION:vim -v
	tmux send-keys -t $SESSION:vim.bottom "cd ${CONFIG_HOME}" Enter
	tmux send-keys -t $SESSION:vim.bottom "clear" Enter
	tmux send-keys -t $SESSION:vim.bottom "dot status" Enter
fi

tmux attach -t $SESSION:vim.bottom