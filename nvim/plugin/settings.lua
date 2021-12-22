local cache = vim.fn.stdpath "cache"
local data = vim.fn.stdpath "data"

-- update file content if it has been modified on disk
vim.opt.autoread = true
-- auto-indent new line
vim.opt.autoindent = true
-- maintain file backup across sessions
vim.opt.backup = true
-- define location for backup files
vim.opt.backupdir = cache .. "/backup//,."
-- allow <backspace> to cross line boundaries
vim.opt.backspace = "indent,eol,start"
-- disable the system bell
vim.opt.belloff = "all"
-- emphasis on wrapped lines
vim.opt.breakindentopt = "shift:2"
-- setup clipboard
vim.opt.clipboard = "unnamedplus"
-- include dictionary in completion matches
vim.opt.complete:append "kspell"
-- use popup menu to show possible completions
vim.opt.completeopt = "menuone,noselect"
-- highlight current line
vim.opt.cursorline = true
-- define location for swap files
vim.opt.directory = cache .. "/swap//,."
-- don't expand spaces to tabs
vim.opt.expandtab = false
-- define glyphs used for vertical separators and statuslines
vim.opt.fillchars = {
  vert = "┃",
  fold = "·",
  diff = "",
  eob = " ",
  foldclose = "",
  foldopen = "",
}
-- grep program to use
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
-- grep output format
vim.opt.grepformat = "%f:%l:%c:%m"
-- allow buffers with unsaved changes to be hidden
vim.opt.hidden = true
-- highlight all search pattern matches
vim.opt.hlsearch = true
-- enable case insensitive search
vim.opt.ignorecase = true
-- enable live text substitution and preview matches
vim.opt.inccommand = "split"
-- incremental highlight of matched patterns
vim.opt.incsearch = true
-- disable padding when joining mulitple lines
vim.opt.joinspaces = false
-- display the statusline
vim.opt.laststatus = 2
-- show whitespace characters
vim.opt.list = true
-- soft line wrapping
vim.opt.linebreak = true
-- define glyphs used to visually identify whitespace
vim.opt.listchars = {
  conceal = "┊",
  eol = "¬",
  extends = "›",
  nbsp = "␣",
  precedes = "‹",
  -- space = "⋅",
  tab = "» ",
  trail = "•",
}
-- enable search using regex expressions
vim.opt.magic = true
-- enable mouse events in normal and visual mode
vim.opt.mouse = "nv"
-- show line numbers
vim.opt.number = true
-- toggle paste mode (to be able to accurately paste from external apps)
vim.opt.pastetoggle = "<F2>"
-- extend path to include current directory
vim.opt.path:append "**"
-- opacity for popup menu
vim.opt.pumblend = 0
-- the maximum number of entries shown in completion menu
vim.opt.pumheight = 5
-- show line numbers relative to current line
vim.opt.relativenumber = true
-- disable showing cursor position in/below statusline
vim.opt.ruler = false
-- rows: begin scrolling before reaching viewport boundary
vim.opt.scrolloff = 3
-- define shada options
vim.opt.shada = {
  "!",
  "'100",
  "<50",
  "s10",
  "h",
  string.format("n%s/shada/main.shada", data),
}
-- space indent width
vim.opt.shiftwidth = 4
-- avoid swapfile alert messages
vim.opt.shortmess:append "A"
-- disable splash screen
vim.opt.shortmess:append "I"
-- disable showing file info
vim.opt.shortmess:append "F"
-- don't show completion menu messages
vim.opt.shortmess:append "c"
-- define line wrap character
vim.opt.showbreak = "⤷"
-- disable showing keystrokes below statusline
vim.opt.showcmd = false
-- disable contextual message based on mode
vim.opt.showmode = false
-- show matching braces
vim.opt.showmatch = true
-- hide the tabline
vim.opt.showtabline = 0
-- columns: begin scrolling before reaching viewport boundary
vim.opt.sidescrolloff = 3
-- make search case sensitive if expression contains a capital letter
vim.opt.smartcase = true
-- indent based on code style
vim.opt.smartindent = true
-- tab will respect 'tabstop', 'shiftwidth', and 'softtabstop'
vim.opt.smarttab = true
-- prevent mixing tabs and whitespace
vim.opt.softtabstop = 0
-- default behaviour when creating horizontal splits
vim.opt.splitbelow = true
-- default behaviour when creating vertical splits
vim.opt.splitright = true
--reuse windows/tabs if possible
vim.opt.switchbuf = "usetab"
-- tab visible width
vim.opt.tabstop = 4
-- enable true color
vim.opt.termguicolors = true
-- set duration to wait for keymap sequence
vim.opt.timeoutlen = 250
-- disable title modification
vim.opt.title = false
-- define location for undo files
vim.opt.undodir = cache .. "/undo//,."
-- maintain undo history across sessions
vim.opt.undofile = true
-- allow crossing of line boundaries
vim.opt.whichwrap = "b,h,l,s,<,>,[,],~"
-- ignore compiled files and temp files
vim.opt.wildignore = { "*.o", "*~", "*.pyc", "*pycache*" }
-- enable enhanced command line completion
vim.opt.wildmenu = true
-- enable file auto-completion
vim.opt.wildmode = "full"
-- enable completion menu
vim.opt.wildoptions = "pum"
-- enable line wrapping
vim.opt.wrap = true
-- define right margin before wrapping text
vim.opt.wrapmargin = 8
