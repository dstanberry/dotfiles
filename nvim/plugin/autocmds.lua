local filesystem = ds.augroup "filesystem"
local ftplugin = ds.augroup "ftplugin"

-- check if current file needs to be reloaded when it changes
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = filesystem,
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
  end,
})
-- create director(y/ies) in path when saving a file
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
  group = filesystem,
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    local dir = vim.fs.dirname(name)
    if not vim.uv.fs_stat(dir) then vim.fn.mkdir(dir, "p") end
  end,
})

-- improve experience when editing git commit messages
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "COMMIT_EDITMSG", "gitcommit" },
  callback = function(args)
    vim.bo[args.buf].swapfile = false
    vim.bo[args.buf].textwidth = 72
    vim.bo[args.buf].undofile = false
    vim.opt_local.backup = false
    vim.opt_local.colorcolumn = "50,72"
    vim.opt_local.foldenable = false
    vim.opt_local.iskeyword:append "-"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = true
    if vim.bo[args.buf].filetype == "COMMIT_EDITMSG" then
      vim.fn.setpos(".", { 0, 1, 1, 0 })
      vim.cmd.startinsert()
    end
  end,
})

-- dont create backups of encrypted files
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "asc", "gpg", "pgp" },
  callback = function()
    vim.bo.backup = false
    vim.bo.swapfile = false
  end,
})

-- change background color of manpages, help and quickfix list and use `q` to close
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "checkhealth", "help", "man", "notify", "qf" },
  callback = function(args)
    if vim.bo[args.buf].filetype == "help" or vim.bo[args.buf].filetype == "qf" then
      vim.opt_local.winhighlight = "Normal:NormalSB"
    end
    vim.keymap.set("n", "q", function()
      vim.cmd.close()
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end, { buffer = args.buf, silent = true })
  end,
})

-- simplify ui for large files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = ftplugin,
  pattern = "bigfile",
  callback = vim.schedule_wrap(
    function(args) vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or "" end
  ),
})

-- disable line numbers and enusre filetype is set for terminal windows
vim.api.nvim_create_autocmd("TermOpen", {
  group = ds.augroup "termui",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = false
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt_local.filetype:get() == "" then vim.opt_local.filetype = "term" end
  end,
})

-- highlighted copied region when yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = ds.augroup "highlight_yank",
  callback = function() vim.hl.on_yank() end,
})

-- define common coding conventions for various programming languages
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "bash", "javascript", "json", "jsonc", "lua", "sh", "typescript", "zsh" },
  callback = function(args)
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    if vim.tbl_contains({ "json", "jsonc", "lua" }, vim.bo[args.buf].filetype) then
      vim.opt_local.colorcolumn = "120"
    else
      vim.opt_local.colorcolumn = "80"
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "cs", "python", "sql" },
  callback = function(args)
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    if vim.bo[args.buf].filetype == "python" then vim.opt_local.colorcolumn = "80" end
    if vim.bo[args.buf].filetype == "sql" then vim.opt_local.relativenumber = false end
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
  callback = function(args)
    local ft = vim.filetype.match { buf = args.buf }
    if ft then
      if not vim.treesitter.language.get_lang(ft) then vim.opt_local.relativenumber = false end
    end
  end,
})
