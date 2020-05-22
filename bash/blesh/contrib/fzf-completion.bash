# ble/contrib/fzf-completion.bash (C) 2020, akinomyoga

ble-import contrib/fzf-initialize

[[ $- == *i* ]] || return 0

source "$_ble_contrib_fzf_base/shell/completion.bash"

# clear blesh completer for cd
blehook/eval-after-load complete 'unset -f ble/cmdinfo/complete:cd'

# patch fzf functions
ble/function#advice around __fzf_generic_path_completion _fzf_complete.advice
ble/function#advice around _fzf_complete                 _fzf_complete.advice
ble/function#advice around _fzf_complete_kill            _fzf_complete.advice
function _fzf_complete.advice {
  [[ :$comp_type: == *:auto:* ]] && return
  compopt -o noquote
  COMP_WORDS=("${comp_words[@]}") COMP_CWORD=$comp_cword
  COMP_LINE=$comp_line COMP_POINT=$comp_point
  ble/function#push printf '[[ $1 == "\e[5n" ]] || builtin printf "$@"'
  ble/function#advice/do <> /dev/tty >&0 2>&0
  ble/function#pop printf
  ble/textarea#invalidate
}
