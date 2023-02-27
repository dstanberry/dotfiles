# shellcheck disable=SC2148

# colorize cat output
hash bat 2> /dev/null && alias cat=bat

# wrap diff commands and colorize the output
hash colordiff 2> /dev/null && alias diff=colordiff

# enable color support for grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# enable color support for ls (using exa)
if hash exa 2> /dev/null; then
  grouped="--group-directories-first --group"
  if is_wsl; then
    alias ls="exa --ignore-glob='ntuser.*|NTUSER.*' --all ${grouped}"
    alias ll="exa --ignore-glob='ntuser.*|NTUSER.*' --long ${grouped} --git-ignore --git --tree"
    alias lla="exa --ignore-glob='ntuser.*|NTUSER.*' --all --long ${grouped} --git-ignore --git --tree"
  else
    alias ls="exa --all ${grouped}"
    alias ll="exa --long ${grouped} --git-ignore --git --tree"
    alias lla="exa --all --long ${grouped} --git-ignore --git --tree"
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
alias reload='source "${ZSH_CONFIG_HOME}/.zshrc"'

# dirty hack to expose native specific Windows utils
if is_wsl; then
  alias open="cmd.exe /c start"
  alias xdg-open="cmd.exe /c start"
  alias code='sh /mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code'
  alias posh='powershell.exe -NoProfile'
fi
