# shellcheck disable=SC2148

# colorize cat output
if hash bat 2> /dev/null; then
  alias cat="bat"
  alias lcat="bat --style=plain"
fi

# wrap diff commands and colorize the output
hash colordiff 2> /dev/null && alias diff=colordiff

# enable color support for grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# enable color support for ls (using eza)
if hash eza 2> /dev/null; then
  grouped="--group-directories-first --group"
  if is_wsl; then
    alias ls="eza --ignore-glob='ntuser.*|NTUSER.*' --icons --all ${grouped}"
    alias ll="eza --ignore-glob='ntuser.*|NTUSER.*' --icons --long ${grouped} --git-ignore --git --tree"
    alias lla="eza --ignore-glob='ntuser.*|NTUSER.*' --icons --all --long ${grouped} --git-ignore --git --tree"
  else
    alias ls="eza --ignore-glob='.*DS_Store' --icons --all ${grouped}"
    alias ll="eza --ignore-glob='.*DS_Store' --icons --long ${grouped} --git-ignore --git --tree"
    alias lla="eza --ignore-glob='ntuser.*|NTUSER.*' --icons --all --long ${grouped} --git-ignore --git --tree"
  fi
fi

# create directory if it does not already exist
alias mkdir="mkdir -p"

# show mount output in table format
alias mount='mount | column -t'

# print row-wise PATH
alias path='echo -e ${PATH//:/\\n}'

# list all active tcp/udp ports
alias ports='sudo netstat -tulanp'

# define alias to reload zsh configuration
alias reload='exec zsh'

# dirty hack to expose native specific Windows utils
if is_wsl; then
  alias open="cmd.exe /c start"
  alias xdg-open="cmd.exe /c start"
  alias code='sh /mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code'
  alias posh='powershell.exe -NoProfile'
fi
