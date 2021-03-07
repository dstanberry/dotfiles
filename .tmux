#!/bin/sh

cd "${0%/*}"

SESSION="dotfiles"
SESSION_AVAILABLE=$(tmux list-sessions | grep $SESSION)
POS="top"

if test -z "$SESSION_AVAILABLE"; then
	tmux new-session -d -s $SESSION -n \
	vim -x $(tput cols) -y $(tput lines)

	if [[ $(tput cols) > 200 ]]; then
		tmux send-keys -t $SESSION:vim "vim -c Files" Enter
		tmux split-window -t $SESSION:vim -h
		tmux send-keys -t $SESSION:vim.right "git status" Enter

		POS="left"
	else
		tmux send-keys -t $SESSION:vim "vim -c Files" Enter
		tmux split-window -t $SESSION:vim -v
		tmux send-keys -t $SESSION:vim.bottom "git status" Enter
	fi
fi

tmux attach -t $SESSION:vim.$POS
