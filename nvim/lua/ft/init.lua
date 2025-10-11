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

---Configures buffer and window options based on filetype and additional options.
---@param buf number The buffer number to configure. Defaults to the current buffer.
---@param options? table<string,boolean|number|string|table> A table of options to configure. Optional: Merges with defaults.
---@param merge_defaults? boolean Whether to merge with default options for the filetype. Defaults to true.
function M.set_options(buf, options, merge_defaults)
  buf = buf or vim.api.nvim_get_current_buf()
  options = options or {}
  if merge_defaults ~= false then
    options = vim.tbl_deep_extend("force", M.defaults[vim.bo[buf].filetype or ""] or {}, options)
  end
  if not vim.api.nvim_buf_is_valid(buf) then return end

  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  local relnum = vim.b[buf].ts_highlight or (ok and parser ~= nil)
  local opts, wo_opts = {}, {}

  if not relnum then wo_opts.relativenumber = false end
  options = vim.tbl_deep_extend("keep", options, wo_opts)
  opts = vim.tbl_deep_extend("force", { scope = "local" }, opts or {})
  for k, v in pairs(options) do
    vim.api.nvim_set_option_value(k, v, opts)
  end
end

---Tree-sitter utilities for parsing and processing syntax trees.
---@alias ft.treesitter.action function
---@type table<string,ft.treesitter.action>
M.treesitter = {}

---Parses the syntax tree of a buffer using Tree-sitter and applies a callback
---@param lang string The language to parse
---@param bufnr number The buffer number to parse.
---@param callback fun(tree: userdata) The function to call for each syntax tree.
function M.treesitter.parse(lang, bufnr, callback)
  local root_parser = vim.treesitter.get_parser(bufnr)
  if not root_parser then return end
  root_parser:parse(true)
  root_parser:for_each_tree(function(TStree, language_tree)
    local tree_language = language_tree:lang()
    if tree_language == lang then callback(TStree) end
  end)
end

return M
