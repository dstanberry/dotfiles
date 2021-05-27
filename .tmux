#!/bin/sh
cd "${0%/*}" || exit

SESSION="dotfiles"
SESSION_AVAILABLE=$(tmux list-sessions | grep $SESSION)
ACTIVE="bottom"

if test -z "$SESSION_AVAILABLE"; then
  tmux new-session -d -s $SESSION -n \
    nvim -x "$(tput cols)" -y "$(tput lines)"

  if [ "$(tput cols)" -gt 200 ]; then
    ACTIVE="right"
    tmux send-keys -t $SESSION:nvim "git status" Enter
    tmux split-window -t $SESSION:nvim -h
    tmux send-keys -t $SESSION:nvim.$ACTIVE "nvim" Enter
  else
    tmux send-keys -t $SESSION:nvim "git status" Enter
    tmux split-window -t $SESSION:nvim -v
    tmux send-keys -t $SESSION:nvim.$ACTIVE "nvim" Enter
  fi
fi

tmux attach -t $SESSION:nvim.$ACTIVE
