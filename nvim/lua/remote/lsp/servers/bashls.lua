---@class remote.lsp.config
local M = {}

M.config = {
  on_attach = function(_, bufnr)
    if vim.api.nvim_buf_get_name(bufnr):match "%.env" then
      vim.schedule(function() vim.cmd "LspStop ++force bashls" end)
    end
  end,
}

return M
