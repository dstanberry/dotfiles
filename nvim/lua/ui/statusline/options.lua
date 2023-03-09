local defaults = {
  disabled_filetypes = {},
  separators = {
    left = { separator = " " },
    right = { separator = " " },
  },
  icons = true,
  sections = {
    left = {
      { component = "mode" },
      { component = "filename" },
    },
    right = {},
  },
  winbar = {
    left = {
      { component = "filename" },
    },
  },
}

local options = vim.deepcopy(defaults)

local M = {}

M.set = function(opts) options = vim.tbl_deep_extend("force", options, opts) end

M.get = function() return options end

M.reset = function() options = vim.deepcopy(defaults) end

return M
