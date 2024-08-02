if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_tmux_session_bindings_custom_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_tmux_session_bindings_custom_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_tmux_session_bindings_custom_options+=" -o $__fzf_opt"
      else
        __fzf_tmux_session_bindings_custom_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{
  [[ -o interactive ]] || return 0

  # CTRL-P - start a tmux session at the selected directory
  fzf-session-widget() {
    local project_dirs worktree_dirs worktree_list
    local res_a res_b selected_dir session_name
    {
      # shellcheck disable=SC2153
      for f in "$HOME/Git"/*; do
        if [ -d "$f" ]; then
          if [ -d "$f/worktrees" ] || [ -d "$f/.git/worktrees" ]; then
            worktree_list=$(git -C "$f" worktree list 2> /dev/null | awk '{print $1}')
            if [ -n "$worktree_list" ]; then
              # shellcheck disable=SC2066
              for w in "$worktree_list"; do
                worktree_dirs="$worktree_dirs $w"
              done
            fi
          fi
        fi
      done
      # shellcheck disable=SC2153
      for f in "$HOME/Projects"/*/*; do
        if [ -d "$f" ]; then
          if [ -z "$project_dirs" ]; then
            project_dirs="$f"
          else
            project_dirs="$project_dirs $f"
          fi
          if [ -d "$f/worktrees" ] || [ -d "$f/.git/worktrees" ]; then
            worktree_list=$(git -C "$f" worktree list 2> /dev/null | awk '{print $1}')
            if [ -n "$worktree_list" ]; then
              # shellcheck disable=SC2066
              for w in "$worktree_list"; do
                worktree_dirs="$worktree_dirs $w"
              done
            fi
          fi
        fi
      done
      # shellcheck disable=SC2207
      project_dirs=($(echo "$project_dirs" | cut -d " " --output-delimiter=" " -f 1-))
      worktree_dirs=($(echo "$worktree_dirs" | cut -d " " --output-delimiter=" " -f 1-))
      res_a=$(find -L "$HOME/Git" "$HOME/Projects" \
        -maxdepth 1 -type d)
      res_b=$(find -L "$XDG_CONFIG_HOME" "${project_dirs[@]}" "${worktree_dirs[@]}" \
        -maxdepth 0 -type d)
    # shellcheck disable=SC2059
      selected_dir=$(printf "$res_a""%s\n""$res_b" | sort -V | uniq | FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS-} \
          --height=100% \
          --reverse --header='Create/Open Session' \
          --preview '(glow -s dark {1}/README.md ||
            bat --style=plain {1}/README.md ||
            cat {1}/README.md ||
            eza -lh --icons {1} ||
            ls -lh {1}) 2> /dev/null'" $(__fzfcmd))
      setopt localoptions pipefail no_aliases 2> /dev/null
      if [[ -z "$selected_dir" ]]; then
        zle redisplay
        return 0
      fi
      session_name="$(basename "$selected_dir" | tr . _)"
      [ -z "$selected_dir" ] && return 1
    } always {
      zle reset-prompt
    }
    (
      exec </dev/tty; exec <&1;
      if [[ -z "$TMUX" ]]; then
       { tmux new-session -As "$session_name" -c "$selected_dir" } || tmux
      else
        if ! tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"; then
          (TMUX='' tmux new-session -Ad -s "$session_name" -c "$selected_dir")
        fi
        tmux switch-client -t "$session_name"
      fi
      unset project_dirs worktree_dirs worktree_list
      unset res_a res_b selected_dir session_name
    )
  }

  zle     -N            fzf-session-widget
  bindkey -M emacs '^P' fzf-session-widget
  bindkey -M vicmd '^P' fzf-session-widget
  bindkey -M viins '^P' fzf-session-widget
} always {
  eval $__fzf_tmux_session_bindings_custom_options
  'unset' '__fzf_tmux_session_bindings_custom_options'
}
