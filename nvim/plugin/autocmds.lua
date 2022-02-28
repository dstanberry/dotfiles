vim.api.nvim_create_augroup { name = "cmdline", clear = true }

vim.api.nvim_create_autocmd {
  group = "cmdline",
  event = "CmdLineEnter",
  callback = function()
    vim.opt.smartcase = false
  end,
}

vim.api.nvim_create_autocmd {
  group = "cmdline",
  event = "CmdLineLeave",
  callback = function()
    vim.opt.smartcase = true
  end,
}

vim.api.nvim_create_augroup { name = "ftplugin", clear = true }

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "BufEnter",
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    vim.cmd [[startinsert]]
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "Filetype",
  callback = function()
    vim.bo.formatoptions = "cjlnqr"
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "Filetype",
  pattern = { "asc", "gpg", "pgp" },
  callback = function()
    vim.bo.backup = false
    vim.bo.swapfile = false
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "FileType",
  pattern = { "bash", "lua", "sh", "zsh" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "FileType",
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.bo.backup = false
    vim.bo.spell = true
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.wo.foldenable = false
    vim.wo.spell = true
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "FileType",
  pattern = "sql",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.relativenumber = false
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
}

vim.api.nvim_create_autocmd {
  group = "ftplugin",
  event = "FileType",
  pattern = "vim",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.wo.foldmethod = "marker"
  end,
}

vim.api.nvim_create_augroup { name = "terminal_ui", clear = true }

vim.api.nvim_create_autocmd {
  group = "terminal_ui",
  event = "TermOpen",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
  end,
}

vim.api.nvim_create_autocmd {
  group = "terminal_ui",
  event = "TermClose",
  pattern = "*",
  command = "execute 'bdelete! ' . expand('<abuf>')",
}

vim.api.nvim_create_augroup { name = "fold_behaviour", clear = true }

vim.api.nvim_create_autocmd {
  group = "fold_behaviour",
  event = "BufEnter",
  callback = function()
    vim.wo.foldenable = false
    vim.wo.foldlevel = 99
    vim.wo.foldtext = "v:lua.fold_text()"
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.fold_expr(v:lnum)"
  end,
}

vim.api.nvim_create_augroup { name = "yank_highlight", clear = true }

vim.api.nvim_create_autocmd {
  group = "yank_highlight",
  event = "TextYankPost",
  callback = vim.highlight.on_yank,
}
