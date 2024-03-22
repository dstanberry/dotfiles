local cursorline = vim.api.nvim_create_augroup("cursorline", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = cursorline,
  callback = function() vim.opt_local.cursorline = true end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = cursorline,
  pattern = "TelescopePrompt",
  callback = function() vim.opt_local.cursorline = false end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = cursorline,
  callback = function() vim.opt_local.cursorline = false end,
})

local cmdline = vim.api.nvim_create_augroup("cmdline", { clear = true })
vim.api.nvim_create_autocmd("CmdLineEnter", {
  group = cmdline,
  callback = function() vim.o.smartcase = false end,
})
vim.api.nvim_create_autocmd("CmdLineLeave", {
  group = cmdline,
  callback = function() vim.o.smartcase = true end,
})

local filesystem = vim.api.nvim_create_augroup("filesystem", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = filesystem,
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
  end,
})
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
  group = filesystem,
  pattern = "*",
  callback = function(event)
    local name = vim.api.nvim_buf_get_name(event.buf)
    local dir = vim.fs.dirname(name)
    if not vim.uv.fs_stat(dir) then vim.fn.mkdir(dir, "p") end
  end,
})

local ftplugin = vim.api.nvim_create_augroup("ftplugin", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
  group = ftplugin,
  pattern = "*",
  callback = function() vim.bo.formatoptions = "cjlnqr" end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = ftplugin,
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    vim.cmd.startinsert()
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "COMMIT_EDITMSG", "gitcommit", "NeogitCommitMessage" },
  callback = function()
    vim.bo.swapfile = false
    vim.bo.textwidth = 72
    vim.bo.undofile = false
    vim.opt_local.backup = false
    vim.opt_local.colorcolumn = "50,72"
    vim.opt_local.foldenable = false
    vim.opt_local.iskeyword:append "-"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd("Filetype", {
  group = ftplugin,
  pattern = { "asc", "gpg", "pgp" },
  callback = function()
    vim.bo.backup = false
    vim.bo.swapfile = false
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "bash", "javascript", "sh", "typescript", "zsh" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.opt_local.colorcolumn = "80"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "json", "jsonc", "lua" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.opt_local.colorcolumn = "120"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = "python",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.opt_local.colorcolumn = "80"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = "sql",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    vim.opt_local.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = "vim",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.colorcolumn = "120"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "help", "qf" },
  callback = function() vim.opt_local.winhighlight = "Normal:NormalSB" end,
})

vim.api.nvim_create_autocmd("Filetype", {
  group = ftplugin,
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldtext = [[v:lua.require("util.buffer").fold_text()]]
    if not pcall(vim.treesitter.start) then return end
    if vim.opt_local.filetype:get() == "typescript" or vim.opt_local.filetype:get() == "tsx" then return end
    vim.opt_local.foldexpr = [[v:lua.require("util.buffer").fold_expr()]]
    vim.opt_local.foldmethod = "expr"
    vim.cmd.normal "zx"
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  group = ftplugin,
  pattern = { "help", "man", "qf" },
  callback = function(event) vim.keymap.set("n", "q", vim.cmd.close, { buffer = event.buf, silent = true, nowait = true }) end,
})

local terminal_ui = vim.api.nvim_create_augroup("terminal_ui", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_ui,
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
    if vim.opt_local.filetype:get() == "" then vim.opt_local.filetype = "term" end
  end,
})

local yank_highlight = vim.api.nvim_create_augroup("yank_highlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_highlight,
  callback = function() vim.highlight.on_yank() end,
})
