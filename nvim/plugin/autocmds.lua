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
  callback = function(args)
    if args.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fs.dirname(file), "p")
  end,
})

-- automatically try to format the document when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = filesystem,
  callback = function(event) ds.format.format { buf = event.buf } end,
})

-- change the default background color of certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "help", "qf" },
  callback = function() vim.opt_local.winhighlight = "Normal:NormalSB" end,
})

-- use `q` to close buffers associated with certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = ds.ft.quick_close,
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd.close()
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end, { buffer = args.buf, silent = true, desc = "close buffer" })
    end)
  end,
})

-- disable line numbers and enusre filetype is set for terminal windows
vim.api.nvim_create_autocmd("TermOpen", {
  group = ds.augroup "termui",
  callback = function(args)
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    if vim.bo[args.buf].filetype == "" then vim.bo[args.buf].filetype = "term" end
  end,
})

-- highlighted copied region when yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = ds.augroup "highlight_yank",
  callback = function() vim.hl.on_yank() end,
})

-- define common conventions for various filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  callback = function(args) ds.ft.set_options(args.buf) end,
})
