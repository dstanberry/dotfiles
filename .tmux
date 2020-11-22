#!/bin/sh

cd "${0%/*}"

SESSION="dotfiles"
SESSION_AVAILABLE=$(tmux list-sessions | grep $SESSION)

if test -z "$SESSION_AVAILABLE"; then
	tmux new-session -d -s $SESSION -n \
	vim -x $(tput cols) -y $(tput lines)

	tmux send-keys -t $SESSION:vim "vim -c Files" Enter
	tmux split-window -t $SESSION:vim -v
	tmux send-keys -t $SESSION:vim.bottom "git status" Enter
fi

tmux attach -t $SESSION:vim.top
