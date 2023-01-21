vim.api.nvim_create_augroup("cursorline", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = "cursorline",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "cursorline",
  pattern = "TelescopePrompt",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = "cursorline",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_augroup("cmdline", { clear = true })
vim.api.nvim_create_autocmd("CmdLineEnter", {
  group = "cmdline",
  callback = function()
    vim.opt.smartcase = false
  end,
})
vim.api.nvim_create_autocmd("CmdLineLeave", {
  group = "cmdline",
  callback = function()
    vim.opt.smartcase = true
  end,
})

vim.api.nvim_create_augroup("filesystem", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
  group = "filesystem",
  pattern = "*",
  callback = function()
    local d = vim.fn.expand "<afile>:p:h"
    if vim.fn.isdirectory(d) == 0 then
      vim.fn.mkdir(d, "p")
    end
  end,
})

vim.api.nvim_create_augroup("ftplugin", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "ftplugin",
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    vim.cmd.startinsert()
  end,
})
vim.api.nvim_create_autocmd("Filetype", {
  group = "ftplugin",
  pattern = "*",
  callback = function()
    vim.bo.formatoptions = "cjlnqr"
  end,
})
vim.api.nvim_create_autocmd("Filetype", {
  group = "ftplugin",
  pattern = { "asc", "gpg", "pgp" },
  callback = function()
    vim.bo.backup = false
    vim.bo.swapfile = false
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ftplugin",
  pattern = { "bash", "javascript", "lua", "sh", "typescript", "zsh" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ftplugin",
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.bo.backup = false
    vim.bo.spell = true
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.wo.foldenable = false
    vim.wo.spell = true
  end,
})
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = "ftplugin",
  pattern = { "markdown" },
  callback = function()
    require("ft.markdown").highlight_fenced_code_blocks()
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ftplugin",
  pattern = "sql",
  callback = function()
    vim.bo.expandtab = true
    vim.wo.relativenumber = false
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ftplugin",
  pattern = "vim",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.wo.foldmethod = "marker"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = "ftplugin",
  pattern = {
    "dap-repl",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_stacks",
    "dapui_watches",
    "help",
    "NeogitPopup",
    "NeogitStatus",
    "packer",
    "qf",
    "startuptime",
  },
  callback = function()
    vim.opt_local.winhighlight = "Normal:NormalSB"
  end,
})

vim.api.nvim_create_augroup("terminal_ui", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal_ui",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
    if vim.opt_local.filetype:get() == "" then
      vim.opt_local.filetype = "term"
    end
  end,
})
vim.api.nvim_create_autocmd("TermClose", {
  group = "terminal_ui",
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if ft ~= "md_preview" then
      vim.cmd.bdelete { vim.fn.expand "<abuf>", bang = true }
    end
  end,
})

vim.api.nvim_create_augroup("fold_behaviour", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "fold_behaviour",
  callback = function()
    vim.wo.foldenable = false
    vim.wo.foldlevel = 99
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = [[v:lua.require("util.buffer").fold_expr()]]
    vim.wo.foldtext = [[v:lua.require("util.buffer").fold_text()]]
  end,
})

vim.api.nvim_create_augroup("yank_highlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "yank_highlight",
  callback = function()
    vim.highlight.on_yank()
  end,
})
