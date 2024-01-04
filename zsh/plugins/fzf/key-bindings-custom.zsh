if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_key_bindings_custom_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_key_bindings_custom_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_key_bindings_custom_options+=" -o $__fzf_opt"
      else
        __fzf_key_bindings_custom_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{

[[ -o interactive ]] || return 0

# CTRL-P - start a tmux session at the selected directory
fzf-session-widget() {
  local projects_dir=""
  # shellcheck disable=SC2153
  for f in "$PROJECTS_DIR"/*; do
    if [ -z "$projects_dir" ]; then
      projects_dir="$f"
    else
      projects_dir="$projects_dir $f"
    fi
  done
  # shellcheck disable=SC2207
  projects_dir=($(echo "$projects_dir" | cut -d " " --output-delimiter=" " -f 1-))
  local dir=$(find -L "$HOME" "$HOME/Git" "$HOME/Projects" "${projects_dir[@]}" \
    -mindepth 1 -maxdepth 1 -type d \
    | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-100%} ${FZF_DEFAULT_OPTS-} \
      --reverse --header='Create/Open Session' \
      --preview '(glow -s dark {1}/README.md ||
        bat --style=plain {1}/README.md ||
        cat {1}/README.md ||
        eza -lh --icons {1} ||
        ls -lh {1}) 2> /dev/null'" $(__fzfcmd))
  setopt localoptions pipefail no_aliases 2> /dev/null
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  session_name="$(basename "$dir" | tr . _)"
  if [[ -z "$TMUX" ]]; then
    BUFFER=" { tmux new-session -As \"$session_name\" -c \"$dir\" } || tmux"
    zle accept-line
  else
    if ! tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"; then
      (TMUX='' tmux new-session -Ad -s "$session_name" -c "$dir")
    fi
    tmux switch-client -t "$session_name"
  fi
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle     -N            fzf-session-widget
bindkey -M emacs '^P' fzf-session-widget
bindkey -M vicmd '^P' fzf-session-widget
bindkey -M viins '^P' fzf-session-widget

} always {
  eval $__fzf_key_bindings_custom_options
  'unset' '__fzf_key_bindings_custom_options'
}
