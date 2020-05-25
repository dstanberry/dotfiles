###############################################################
# Shell Prompt
###############################################################
# load colors function
autoload -U colors
colors

# load version tracking function
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '%F{cyan} %b%m%c%u%f '
zstyle ':vcs_info:git*:*' actionformats '%F{cyan} %b|%a%m%c%u %f'

function +vi-git-untracked() {
	emulate -L zsh
	if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
		hook_com[unstaged]+="%F{blue}●%f"
	fi
}

# anonymous function to avoid leaking variables.
function () {
	# check for tmux by looking at $TERM, because $TMUX won't be propagated to any
	# nested sudo shells but $TERM will.
	local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
	if [ -n "$TMUXING" -a -n "$TMUX" ]; then
		# in a a tmux session created in a non-root or root shell.
		local LVL=$(($SHLVL - 1))
	else
		# either in a root shell created inside a non-root tmux session,
		# or not in a tmux session.
		local LVL=$SHLVL
	fi
	if [[ $EUID -eq 0 ]]; then
		local PREFIX='%F{red}%f '
	else
		local PREFIX=''
	fi
	if [[ $EUID -eq 0 ]]; then
		local SUFFIX='${vcs_info_msg_0_}%f'$(printf '%%F{green}\u276f%.0s%%f' {1..$LVL})
	else
		local SUFFIX='${vcs_info_msg_0_}%f'$(printf '%%F{green}\u276f%.0s%%f' {1..$LVL})
	fi
	
	# define the primary prompt
	export PS1="${PREFIX}%F{green}${SSH_TTY:+%m}%f%B${SSH_TTY:+ }%b%F{blue}%B%3~%b%F{yellow}%B%(1j.*.)%(?..!)%b%f %B${SUFFIX}%b "
	if [[ -n "$TMUXING" ]]; then
		# outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
		# prompt still gets corrupted even if we add an extra space to compensate.
		export ZLE_RPROMPT_INDENT=0
	fi
}

# define the description used for spelling correction
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f? [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort] "

# don't trigger spell check on dotfiles
export CORRECT_IGNORE_FILE='.*'
