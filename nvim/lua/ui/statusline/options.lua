local defaults = {
  disabled_filetypes = {},
  separators = {
    left = { hl = "", symbol = "" },
    right = { hl = "", symbol = "" },
  },
  icons = true,
  sections = {
    left = {
      { "mode" },
      { "filename" },
    },
    right = {},
  },
  winbar = {
    left = {
      { "filename" },
    },
  },
}

local options = vim.deepcopy(defaults)

local M = {}

M.set = function(opts) options = vim.tbl_deep_extend("force", options, opts) end

M.get = function() return options end

M.reset = function() options = vim.deepcopy(defaults) end

return M
