#!/bin/sh
cd "${0%/*}" || exit

SESSION="dotfiles"
SESSION_AVAILABLE=$(tmux list-sessions | grep $SESSION)
WIN1="top"

if test -z "$SESSION_AVAILABLE"; then
  tmux new-session -d -s $SESSION -n \
    vim -x "$(tput cols)" -y "$(tput lines)"

  if [ "$(tput cols)" -gt 200 ]; then
    tmux send-keys -t $SESSION:vim "vim" Enter
    tmux split-window -t $SESSION:vim -h
    tmux send-keys -t $SESSION:vim.right "git status" Enter

    WIN1="left"
  else
    tmux send-keys -t $SESSION:vim "vim" Enter
    tmux split-window -t $SESSION:vim -v
    tmux send-keys -t $SESSION:vim.bottom "git status" Enter
  fi
fi

tmux attach -t $SESSION:vim.$WIN1
