local cache = vim.fn.stdpath "cache"
local data = vim.fn.stdpath "data"

vim.o.autoread = true -- update file content if it has been modified on disk
vim.o.autoindent = true -- auto-indent new line
vim.o.backup = true -- maintain file backup across sessions
vim.o.backupdir = cache .. "/backup//,." -- define location for backup files
vim.o.backspace = "indent,eol,start" -- allow <backspace> to cross line boundaries
vim.o.belloff = "all" -- disable the system bell
vim.o.breakindentopt = "shift:2" -- emphasis on wrapped lines
vim.o.clipboard = "" -- DON'T DEFINE CLIPBOARD HERE DUE TO STARTUP PENALTY!
vim.o.cmdheight = 1 -- define line-height for command-line
vim.o.cursorline = true -- highlight current line
vim.o.directory = cache .. "/swap//,." -- define location for swap files
vim.o.expandtab = false -- don't expand spaces to tabs
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case" -- grep program to use
vim.o.hidden = true -- allow buffers with unsaved changes to be hidden
vim.o.hlsearch = true -- highlight all search pattern matches
vim.o.ignorecase = true -- enable case insensitive search
vim.o.inccommand = "split" -- enable live text substitution and preview matches
vim.o.incsearch = true -- incremental highlight of matched patterns
vim.o.joinspaces = false -- disable padding when joining mulitple lines
vim.o.laststatus = 3 -- display the statusline
vim.o.list = true -- show whitespace characters
vim.o.linebreak = true -- soft line wrapping
vim.o.magic = true -- enable search using regex expressions
vim.o.mouse = "nv" -- enable mouse events in normal and visual mode
vim.o.mousemodel = "extend" -- prevent showing context-menu on right-click
vim.o.number = true -- show line numbers
vim.o.pumblend = 0 -- opacity for popup menu
vim.o.pumheight = 5 -- the maximum number of entries shown in completion menu
vim.o.relativenumber = true -- show line numbers relative to current line
vim.o.ruler = false -- disable showing cursor position in/below statusline
vim.o.scrolloff = 3 -- rows: begin scrolling before reaching viewport boundary
if ds.has "win32" then -- use powershell on windows OS
  vim.o.shell = "pwsh"
  vim.o.shellcmdflag = table.concat({
    "-NoLogo",
    "-NonInteractive",
    "-ExecutionPolicy RemoteSigned",
    "-Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();",
    "$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
    "$PSStyle.OutputRendering='plaintext';",
    "Remove-Alias -Force -ErrorAction SilentlyContinue tee;",
  }, " ")
  vim.o.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
  vim.o.shellpipe = [[2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode]]
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end
vim.o.shiftwidth = 4 -- space indent width
vim.o.showbreak = "⤷" -- define line wrap character
vim.o.showcmd = false -- disable showing keystrokes below statusline
vim.o.showmode = false -- disable contextual message based on mode
vim.o.showmatch = true -- show matching braces
vim.o.showtabline = 2 -- show the tabline
vim.o.sidescrolloff = 3 -- columns: begin scrolling before reaching viewport boundary
vim.o.smartcase = true -- make search case sensitive if expression contains a capital letter
vim.o.smartindent = true -- indent based on code style
vim.o.smarttab = true -- tab will respect 'tabstop', 'shiftwidth', and 'softtabstop'
vim.o.softtabstop = 0 -- prevent mixing tabs and whitespace
vim.o.splitbelow = true -- default behaviour when creating horizontal splits
vim.o.splitright = true -- default behaviour when creating vertical splits
vim.o.switchbuf = "usetab" --reuse windows/tabs if possible
vim.o.tabstop = 4 -- tab visible width
vim.o.termguicolors = true -- enable true color
vim.o.timeoutlen = 250 -- set duration to wait for keymap sequence
vim.o.title = false -- disable title modification
vim.o.undodir = cache .. "/undo//,." -- define location for undo files
vim.o.undofile = true -- maintain undo history across sessions
vim.o.whichwrap = "b,h,l,s,<,>,[,],~" -- allow crossing of line boundaries
vim.o.wildmenu = true -- enable enhanced command line completion
vim.o.wildmode = "full" -- enable file auto-completion
vim.o.wrap = true -- enable line wrapping
vim.o.wrapmargin = 8 -- define right margin before wrapping text

vim.opt.complete:append "kspell" -- include dictionary in completion matches
vim.opt.completeitemalign = "kind,abbr,menu" -- define the alignment and display order of popup menu items
vim.opt.completeopt = "menuone,noselect" -- use popup menu to show possible completions
vim.opt.diffopt = { -- define diff options
  "internal",
  "filler",
  "closeoff",
  "hiddenoff",
  "algorithm:minimal",
  "linematch:60",
}
vim.opt.fillchars = { -- define glyphs used for vertical separators and statuslines
  vert = "┃",
  fold = "·",
  diff = "",
  eob = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
}
vim.opt.foldexpr = "v:lua.require('util.ui').foldexpr()" -- define the function used to calculate the fold level
vim.opt.foldlevel = 99 -- define the fold level
vim.opt.foldmethod = "expr" -- define how the fold level is calculated
vim.opt.foldtext = "" -- specify the text displayed for a closed fold
vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" } -- grep output format
vim.opt.formatexpr = "v:lua.require('util.format').formatexpr()" -- define the function used for automatic formatting
vim.bo.formatoptions = "cjlnqr" -- define how formatting is to be done
vim.opt.grepprg = "rg --vimgrep" -- define program used to grep files
vim.opt.jumpoptions = "view" -- define the jump list behavior
vim.opt.listchars = { -- define glyphs used to visually identify whitespace
  conceal = "┊",
  eol = "¬",
  extends = "›",
  lead = "·",
  nbsp = "␣",
  precedes = "‹",
  tab = "» ",
  trail = "•",
}
vim.opt.path:append "**" -- extend path to include current directory
vim.opt.shada = { -- define shada options
  "!",
  "'100",
  "<50",
  "s10",
  "h",
  string.format("n%s/shada/main.shada", data),
}

vim.opt.shortmess:append "A" -- avoid swapfile alert messages
vim.opt.shortmess:append "I" -- disable splash screen
vim.opt.shortmess:append "F" -- disable showing file info
vim.opt.shortmess:append "c" -- don't show completion menu messages
vim.opt.signcolumn = "yes" -- show sign column to prevent visual jitter
vim.opt.spelllang = "en_us" -- set preferred language
vim.opt.spelloptions:append "noplainbuffer" -- spell checker can only be available for buffers with a valid filetype
vim.opt.splitkeep = "screen" -- keep text on the same screen line
vim.opt.statuscolumn = [[%!v:lua.require'util.ui'.statuscolumn()]] -- define the function used to populate the statuscolumn
vim.opt.smoothscroll = true -- when line wrap enabled, scroll by screen line instead of by line
vim.opt.updatetime = 200 -- inactive duration before saving to swap file and trigger |CursorHold|
vim.opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
vim.opt.wildignore = { -- list of file patterns to ifnore when expanding wildcards
  "*.dll",
  "*.gif",
  "*.ico",
  "*.jpeg",
  "*.jpg",
  "*.o",
  "*.png",
  "*.png",
  "*.pyc",
  "*/env/*",
  "*/node_modules/*",
  "*pycache*",
  "*~",
  ".DS_Store",
  "ntuser.*",
  "NTUSER.*",
}
vim.opt.wildoptions = { "pum", "fuzzy" } -- enable completion menu
vim.opt.winborder = "" -- define the default border style of floating windows.
