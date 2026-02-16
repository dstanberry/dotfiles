$env:CONFIG_HOME = "$HOME\.config"
$env:CACHE_HOME = "$env:TEMP"
$env:DATA_HOME = "$env:APPDATA"

# define the default editor
$env:EDITOR = "nvim"

# define configuration path for bat
$env:BAT_CONFIG_PATH = "$env:CONFIG_HOME\bat\bat.conf"


# define location of claude code configuration
$env:CLAUDE_CONFIG_DIR = "$env:CONFIG_HOME\claude"

# define configuration path for rust/cargo
$env:CARGO_HOME = "$env:DATA_HOME\cargo"
$env:RUSTUP_HOME = "$env:DATA_HOME\rustup"

# define configuration path for go
$env:GOPATH = "$env:DATA_HOME\go"

# set fd as the default source for fzf
$env:FZF_DEFAULT_COMMAND = "fd -H --follow --type f --color=always -E .git -E 'ntuser.dat\*' -E 'NTUSER.DAT\*'"

$fzf_catppuccin_frappe = "
--color=bg+:#414559
--color=bg:#303446
--color=border:#737994
--color=fg+:#c6d0f5
--color=fg:#c6d0f5
--color=header:#e78284
--color=hl+:#e78284
--color=hl:#e78284
--color=info:#ca9ee6
--color=label:#c6d0f5
--color=marker:#babbf1
--color=pointer:#f2d5cf
--color=prompt:#ca9ee6
--color=selected-bg:#51576d
--color=spinner:#f2d5cf
"

$fzf_catppuccin_macchiato = "
--color=bg+:#363a4f
--color=bg:#24273a
--color=border:#6e738d
--color=fg+:#cad3f5
--color=fg:#cad3f5
--color=header:#ed8796
--color=hl+:#ed8796
--color=hl:#ed8796
--color=info:#c6a0f6
--color=label:#cad3f5
--color=marker:#b7bdf8
--color=pointer:#f4dbd6
--color=prompt:#c6a0f6
--color=selected-bg:#494d64
--color=spinner:#f4dbd6
"

$fzf_catppuccin_mocha = "
--color=bg+:#313244
--color=bg:#1e1e2e
--color=border:#6c7086
--color=fg+:#cdd6f4
--color=fg:#cdd6f4
--color=header:#f38ba8
--color=hl+:#f38ba8
--color=hl:#f38ba8
--color=info:#cba6f7
--color=label:#cdd6f4
--color=marker:#b4befe
--color=pointer:#f5e0dc
--color=prompt:#cba6f7
--color=selected-bg:#45475a
--color=spinner:#f5e0dc
"

$fzf_kdark = "
--color=bg+:#303031
--color=bg:#303031
--color=border:#303031
--color=fg+:#d8dee9
--color=fg:#b8bec9
--color=gutter:#303031
--color=header:#6f8fb4
--color=hl+:#97b182
--color=hl:#7f966d
--color=info:#59595e
--color=marker:#bf616a
--color=pointer:#b8bec9
--color=preview-bg:#1f2021
--color=preview-border:#59595e
--color=preview-scrollbar:#3a3c3d
--color=prompt:#7f966d
--color=scrollbar:#373737
--color=spinner:#5f8f9d
"

$fzf_tokyonight = "
--color=bg+:#283457
--color=bg:#16161e
--color=border:#27a1b9
--color=fg:#c0caf5
--color=gutter:#16161e
--color=header:#ff9e64
--color=hl+:#2ac3de
--color=hl:#2ac3de
--color=info:#545c7e
--color=marker:#ff007c
--color=pointer:#ff007c
--color=prompt:#2ac3de
--color=query:#c0caf5:regular
--color=scrollbar:#27a1b9
--color=separator:#ff9e64
--color=spinner:#ff007c
"

$fzf_tokyonight_storm = "
--color=bg+:#2e3c64
--color=bg:#1f2335
--color=border:#29a4bd
--color=fg:#c0caf5
--color=gutter:#1f2335
--color=header:#ff9e64
--color=hl+:#2ac3de
--color=hl:#2ac3de
--color=info:#545c7e
--color=marker:#ff007c
--color=pointer:#ff007c
--color=prompt:#2ac3de
--color=query:#c0caf5:regular
--color=scrollbar:#29a4bd
--color=separator:#ff9e64
--color=spinner:#ff007c
"

# define default options for fzf
$env:FZF_DEFAULT_OPTS = "
--ansi
--border
--cycle
--header-first
--height=50%
--margin=1,2,1,2
--layout=reverse
--preview-window=border-thinblock
--scroll-off=3
--bind=ctrl-d:preview-down
--bind=ctrl-f:preview-up
--bind=tab:toggle-out
--bind=shift-tab:toggle-in
--prompt=' '
--pointer=''
--marker=''
--scrollbar='▌▐'
--color=dark
$fzf_kdark
"

# define default behaviour for ctrl-t
$env:FZF_CTRL_T_OPTS = "
--select-1
--exit-0
--preview '(bat --style=plain {} || cat {} || tree -C {}) | head -200'
"

# define default name of primary upstream git branch
$env:GIT_REVIEW_BASE = "main"

# enable terminal colors in output
$env:GH_FORCE_TTY = "100%"
# define path to configuration files
$env:GH_CONFIG_DIR = "$env:CONFIG_HOME\gh"

# define the default configuration path for komorebi
$env:KOMOREBI_CONFIG_HOME = "$HOME\.config\komorebi"
# define the default configuration path for whkd
$env:WHKD_CONFIG_HOME = "$HOME\.config\komorebi"

# set sane default options for less
$env:LESS = "-iFMRX -x4"
# define the default pager
$env:PAGER = "less"

# define the default manpager
$env:MANPAGER = 'nvim +Man!'

# define location for local projects
$env:PROJECTS_DIR = $global:basedir + "Projects"

$env:PSQLRC = "$env:CONFIG_HOME\pg\psqlrc-win"
$env:PSQL_HISTORY = "$env:CACHE_HOME\pg\psql_history"
$env:PGPASSFILE = "$env:CONFIG_HOME\pg\pgpass"
$env:PGSERVICEFILE = "$env:CONFIG_HOME\pg\pg_service.conf"

# prevent virtualenv from automatically modifying prompt
$env:VIRTUAL_ENV_DISABLE_PROMPT = $true

# define location of zettelkasten vault
$env:ZK_NOTEBOOK_DIR = $global:basedir + "Documents\_notes\zettelkasten\vault"
