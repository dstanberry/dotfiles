local cache = vim.fn.stdpath "cache"
local data = vim.fn.stdpath "data"

-- update file content if it has been modified on disk
vim.o.autoread = true
-- auto-indent new line
vim.o.autoindent = true
-- maintain file backup across sessions
vim.o.backup = true
-- define location for backup files
vim.o.backupdir = cache .. "/backup//,."
-- allow <backspace> to cross line boundaries
vim.o.backspace = "indent,eol,start"
-- disable the system bell
vim.o.belloff = "all"
-- emphasis on wrapped lines
vim.o.breakindentopt = "shift:2"
-- setup clipboard
vim.o.clipboard = "unnamedplus"
-- define line-height for command-line
vim.o.cmdheight = 1
-- include dictionary in completion matches
vim.opt.complete:append "kspell"
-- use popup menu to show possible completions
vim.opt.completeopt = "menuone,noselect"
-- highlight current line
vim.o.cursorline = true
-- define diff options
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "hiddenoff",
  "algorithm:minimal",
  "linematch:60",
}
-- define location for swap files
vim.o.directory = cache .. "/swap//,."
-- don't expand spaces to tabs
vim.o.expandtab = false
-- define glyphs used for vertical separators and statuslines
vim.opt.fillchars = {
  vert = "┃",
  fold = "·",
  diff = "",
  eob = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
}
-- grep program to use
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
-- grep output format
vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
-- allow buffers with unsaved changes to be hidden
vim.o.hidden = true
-- highlight all search pattern matches
vim.o.hlsearch = true
-- enable case insensitive search
vim.o.ignorecase = true
-- enable live text substitution and preview matches
vim.o.inccommand = "split"
-- incremental highlight of matched patterns
vim.o.incsearch = true
-- disable padding when joining mulitple lines
vim.o.joinspaces = false
-- display the statusline
vim.o.laststatus = 3
-- show whitespace characters
vim.o.list = true
-- soft line wrapping
vim.o.linebreak = true
-- define glyphs used to visually identify whitespace
vim.opt.listchars = {
  conceal = "┊",
  eol = "¬",
  extends = "›",
  lead = "·",
  nbsp = "␣",
  precedes = "‹",
  tab = "» ",
  trail = "•",
}
-- enable search using regex expressions
vim.o.magic = true
-- enable mouse events in normal and visual mode
vim.o.mouse = "nv"
-- prevent showing context-menu on right-click
vim.o.mousemodel = "extend"
-- show line numbers
vim.o.number = true
-- extend path to include current directory
vim.opt.path:append "**"
-- opacity for popup menu
vim.o.pumblend = 0
-- the maximum number of entries shown in completion menu
vim.o.pumheight = 5
-- show line numbers relative to current line
vim.o.relativenumber = true
-- disable showing cursor position in/below statusline
vim.o.ruler = false
-- rows: begin scrolling before reaching viewport boundary
vim.o.scrolloff = 3
-- define shada options
vim.opt.shada = {
  "!",
  "'100",
  "<50",
  "s10",
  "h",
  string.format("n%s/shada/main.shada", data),
}
-- use powershell on windows OS
if has "win32" then
  vim.o.shell = "pwsh"
  vim.o.shellcmdflag = table.concat({
    "-NoLogo",
    "-ExecutionPolicy RemoteSigned",
    "-Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  }, " ")
  vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end
-- space indent width
vim.o.shiftwidth = 4
-- avoid swapfile alert messages
vim.opt.shortmess:append "A"
-- disable splash screen
vim.opt.shortmess:append "I"
-- disable showing file info
vim.opt.shortmess:append "F"
-- don't show completion menu messages
vim.opt.shortmess:append "c"
-- define line wrap character
vim.o.showbreak = "⤷"
-- disable showing keystrokes below statusline
vim.o.showcmd = false
-- disable contextual message based on mode
vim.o.showmode = false
-- show matching braces
vim.o.showmatch = true
-- show the tabline
vim.o.showtabline = 2
-- columns: begin scrolling before reaching viewport boundary
vim.o.sidescrolloff = 3
-- make search case sensitive if expression contains a capital letter
vim.o.smartcase = true
-- indent based on code style
vim.o.smartindent = true
-- tab will respect 'tabstop', 'shiftwidth', and 'softtabstop'
vim.o.smarttab = true
-- prevent mixing tabs and whitespace
vim.o.softtabstop = 0
-- default behaviour when creating horizontal splits
vim.o.splitbelow = true
-- default behaviour when creating vertical splits
vim.o.splitright = true
--reuse windows/tabs if possible
vim.o.switchbuf = "usetab"
-- tab visible width
vim.o.tabstop = 4
-- enable true color
vim.o.termguicolors = true
-- set duration to wait for keymap sequence
vim.o.timeoutlen = 250
-- disable title modification
vim.o.title = false
-- define location for undo files
vim.o.undodir = cache .. "/undo//,."
-- maintain undo history across sessions
vim.o.undofile = true
-- allow crossing of line boundaries
vim.o.whichwrap = "b,h,l,s,<,>,[,],~"
-- ignore compiled files and temp files
vim.opt.wildignore = {
  "*.o",
  "*~",
  "*.pyc",
  "*pycache*",
  "*.dll",
  "*.gif",
  "*.ico",
  "*.jpeg",
  "*.jpg",
  "*.png",
  "*.png",
  ".DS_Store",
  "ntuser.*",
  "NTUSER.*",
}
-- enable enhanced command line completion
vim.o.wildmenu = true
-- enable file auto-completion
vim.o.wildmode = "full"
-- enable completion menu
vim.opt.wildoptions = { "pum", "fuzzy" }
-- enable line wrapping
vim.o.wrap = true
-- define right margin before wrapping text
vim.o.wrapmargin = 8
