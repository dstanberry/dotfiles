---@class util.ft.base
---@field css ft.css
---@field defaults ft.defaults
---@field html ft.html
---@field lua ft.lua
---@field markdown ft.markdown
---@field python ft.python
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("ft." .. k)
    return rawget(t, k)
  end,
})

---Options module for configuring buffer-local and window-local settings.
---@alias ft.options.kind fun(name: string, value: any, opts?: vim.api.keyset.option)
---@type table<string,ft.options.kind>
M.options = {}

---Sets buffer-local options for a given buffer.
---@param buf number The buffer number to set options for.
---@param bo table<string, any> A table of buffer-local options to set.
---@param opts? vim.api.keyset.option Additional options for setting the buffer.
function M.options.bo(buf, bo, opts)
  bo = bo or {}
  opts = vim.tbl_deep_extend("force", { buf = buf }, opts or {})
  for k, v in pairs(bo) do
    vim.api.nvim_set_option_value(k, v, opts)
  end
end

---Sets window-local options for a given window.
---@param win number The window number to set options for.
---@param wo table<string, any> A table of window-local options to set.
---@param opts? vim.api.keyset.option Additional options for setting the buffer.
function M.options.wo(win, wo, opts)
  wo = wo or {}
  opts = vim.tbl_deep_extend("force", { scope = "local", win = win }, opts or {})
  for k, v in pairs(wo) do
    vim.api.nvim_set_option_value(k, v, opts)
  end
end

---Tree-sitter utilities for parsing and processing syntax trees.
---@alias ft.treesitter.action function
---@type table<string,ft.treesitter.action>
M.treesitter = {}

---Parses the syntax tree of a buffer using Tree-sitter and applies a callback to Python trees.
---@param lang string The language to parse
---@param bufnr number The buffer number to parse.
---@param callback fun(tree: userdata) The function to call for each Python syntax tree.
function M.treesitter.parse(lang, bufnr, callback)
  local root_parser = vim.treesitter.get_parser(bufnr)
  if not root_parser then return end
  root_parser:parse(true)
  root_parser:for_each_tree(function(TStree, language_tree)
    local tree_language = language_tree:lang()
    if tree_language == lang then callback(TStree) end
  end)
end

---Configures buffer and window options based on filetype and additional options.
---@param buf number The buffer number to configure. Defaults to the current buffer.
---@param opts? table<string, any> A table of options to configure. Merges with defaults.
function M.set_options(buf, opts)
  buf = buf or vim.api.nvim_get_current_buf()
  opts = vim.tbl_deep_extend("force", M.defaults[vim.bo[buf].filetype or ""] or {}, opts or {})

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    opts = vim.tbl_deep_extend("keep", opts, {
      wo = { relativenumber = vim.b[buf].ts_highlight or (ok and parser ~= nil) },
    })
    M.options.wo(win, opts.wo)
  end

  M.options.bo(buf, opts.bo)
end

return M
