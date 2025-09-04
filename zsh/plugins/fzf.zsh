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

  # <...> - interact with github pull requests in the current repository
  fzf-gh-pr-widget() {
    fzf --ansi --height="100%" \
      --info inline --reverse --header-lines 4 \
      --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr view --comments {1}' \
      --preview-window up:border-down \
      --bind 'start:preview(echo Loading pull requests ...)+reload:GH_FORCE_TTY=95% gh pr list --limit=1000' \
      --bind 'load:transform:(( FZF_TOTAL_COUNT )) || echo become:echo No pull requests' \
      --bind 'ctrl-o:execute-silent:gh pr view --web {1}' \
      --bind 'ctrl-v:become:pr={1} && gh pr checkout {1} && nvim -c ":Octo pr edit ${pr#"#"}"' \
      --bind 'enter:become:gh pr checkout {1}' \
      --footer 'Press Enter to checkout / CTRL-O to open in browser / CTRL-V to open in eitor' "$@"
  }

  # <CTRL-F> - recursively search the current directory for a provided pattern
  fzf-rg-widget() {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --height="100%" \
      --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
      --bind "ctrl-r:unbind(ctrl-r)+change-prompt(ripgrep )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
      --bind 'enter:become(nvim {1} +{2})' \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --prompt 'ripgrep ' \
      --delimiter : \
      --preview 'bat --style=numbers {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --footer '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱'
  }

  zle     -N            fzf-rg-widget
  bindkey -M emacs '^F' fzf-rg-widget
  bindkey -M vicmd '^F' fzf-rg-widget
  bindkey -M viins '^F' fzf-rg-widget

  # <CTRL-P> - start a tmux session at the selected directory
  fzf-session-widget() {
    local -a project_dirs worktree_dirs
    local selected_dir session_name res_a res_b

    _get_worktrees() {
      local repo="$1" list
      [[ -d $repo ]] || return 0
      if [[ -d $repo/worktrees || -d $repo/.git/worktrees ]]; then
        list=$(git -C "$repo" worktree list 2>/dev/null | awk '{print $1}')
        [[ -n $list ]] || return 0
        print -rl -- $list
      fi
    }
    for d in "$HOME"/Git/*; do
      [[ -d $d ]] || continue
      while IFS= read -r w; do worktree_dirs+="$w"; done < <(_get_worktrees "$d")
    done
    for d in "$HOME"/Projects/*/*; do
      [[ -d $d ]] || continue
      project_dirs+="$d"
      while IFS= read -r w; do worktree_dirs+="$w"; done < <(_get_worktrees "$d")
    done
    res_a=$(find -L "$HOME/Git" "$HOME/Projects" -maxdepth 1 -type d 2>/dev/null)
    res_b=$(find -L "${XDG_CONFIG_HOME}" ${project_dirs:+"${project_dirs[@]}"} \
      ${worktree_dirs:+"${worktree_dirs[@]}"} -maxdepth 0 -type d 2>/dev/null)
    {
      selected_dir=$(
        printf "%s\n%s\n" "$res_a" "$res_b" | sort -V | uniq |
        fzf --height=100% --reverse \
          --header 'Create/Open Session' \
          --preview '(glow -s dark {1}/README.md ||
            bat --style=plain {1}/README.md || cat {1}/README.md ||
            eza -lh --color=always --icons --git {1} ||
            ls -lh {1}) 2> /dev/null'
      )
      if [ -z "$selected_dir" ]; then
        zle redisplay
        return 0
      fi
      session_name=$(basename "$selected_dir" | tr . _)
      [ -n "$session_name" ] || return 1
      } always {
      zle reset-prompt
    }
    (
      exec </dev/tty; exec <&1;
      if [ -z "$TMUX" ]; then
        tmux new-session -As "$session_name" -c "$selected_dir" >/dev/null || tmux
      else
        if ! tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"; then
          (TMUX='' tmux new-session -Ad -s "$session_name" -c "$selected_dir")
        fi
        tmux switch-client -t "$session_name"
      fi
      unset project_dirs worktree_dirs res_a res_b selected_dir session_name
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
