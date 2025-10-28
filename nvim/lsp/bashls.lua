---@class remote.lsp.config
local M = {}

M.config = {
  on_attach = function(_, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fs.basename(fname):match "^%.env" then vim.schedule(function() vim.cmd "LspStop bashls" end) end
  end,
}

return function() return M end
