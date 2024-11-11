---@class util.hl
local M = {}

local _cache = {}

---@type util.theme.hl
local highlight_groups = setmetatable({}, {
  ---@param name string
  ---@param args? vim.api.keyset.highlight
  __newindex = function(_, name, args)
    args = type(args) == "string" and { link = args } or args
    vim.api.nvim_set_hl(0, name, args)
  end,
})

--- Autocmd group id to be used for `ColorScheme` events
M.autocmd_group = ds.augroup "theme_highlights"

--- Used by `mini.hipatterns` to toggle live preview of highlight groups by name
M.show_preview = false

--- Adds a new or updates an existing highlight group
---@param name string
---@param args? vim.api.keyset.highlight
M.add = function(name, args)
  highlight_groups[name] = args
  _cache[name] = args
end

--- Sets and caches highlight groups
---@param groups util.theme.hl
M.set = function(groups)
  for k, v in pairs(groups) do
    highlight_groups[k] = v
    _cache[k] = v
  end
end

--- Returns a copy of currently cached highlight group definitions
---@return util.theme.hl
M.get = function() return vim.deepcopy(_cache) end

return M
