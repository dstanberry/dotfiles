local M = {}

---@private
local N = {}

---@type table<string, fun(theme: util.theme.name, data?: util.theme.cache): string|nil|util.theme.cache>
N.cache = {}

---@type { groups: string, palettes: string, root: string }
N.dirs = {
  groups = "/theme/groups/",
  palettes = "/theme/palette/",
  root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h"),
}

---@type util.theme.hl[]
N.groups = {}

---@param theme util.theme.name
N.cache.file = function(theme) return vim.fs.joinpath(vim.fn.stdpath "cache", ("colorscheme-%s.json"):format(theme)) end

---@param theme util.theme.name
N.cache.read = function(theme)
  ---@type boolean, util.theme.cache
  local ok, ret = pcall(
    function()
      return vim.json.decode(ds.fs.read(N.cache.file(theme), "r", true), { luanil = { object = true, array = true } })
    end
  )
  return ok and ret or nil
end

---@param theme util.theme.name
---@param data util.theme.cache
N.cache.write = function(theme, data) pcall(ds.fs.write, N.cache.file(theme), vim.json.encode(data), "w+") end

---@param theme util.theme.name
N.cache.clear = function(theme) vim.uv.fs_unlink(N.cache.file(theme)) end

--- Defines highlight groups using the provided color palette
---@param theme util.theme.name
---@param c util.theme.palette
M.apply = function(theme, c)
  ds.fs.walk(N.dirs.root .. N.dirs.groups, function(path, name, kind)
    if (kind == "file" or kind == "link") and name:match "%.lua$" then
      name = path:match(N.dirs.root .. N.dirs.groups .. "/(.*)"):sub(1, -5):gsub("/", ".")
      table.insert(N.groups, name)
    end
  end)

  local cache = N.cache.read(theme)
  local inputs = { colors = c, plugins = N.groups }
  -- local g = cache and vim.deep_equal(inputs, cache.inputs) and cache.groups
  local g

  if not g then
    g = {}
    for _, mod in ipairs(N.groups) do
      local spec = loadfile(vim.fs.joinpath(N.dirs.root .. N.dirs.groups, mod .. ".lua"))()
      local t_mod = vim.fs.joinpath(N.dirs.root .. N.dirs.palettes, theme:gsub("%-.*", ""), "groups", mod .. ".lua")
      local t_spec = vim.uv.fs_stat(t_mod) and loadfile(t_mod)().get(c)
      for k, v in pairs(spec.get(c)) do
        g[k] = v
        if t_spec and t_spec[k] ~= nil then g[k] = t_spec[k] end
      end
      N.cache.write(theme, { groups = g, inputs = inputs })
    end
  end

  ds.hl.set(g)

  -- ensure termguicolors is set (likely redundant)
  vim.o.termguicolors = true
  -- define terminal color palette
  vim.g.terminal_color_0 = c.bg2
  vim.g.terminal_color_1 = c.red1
  vim.g.terminal_color_2 = c.green2
  vim.g.terminal_color_3 = c.yellow2
  vim.g.terminal_color_4 = c.blue2
  vim.g.terminal_color_5 = c.magenta1
  vim.g.terminal_color_6 = c.cyan2
  vim.g.terminal_color_7 = c.fg1
  vim.g.terminal_color_8 = c.gray1
  vim.g.terminal_color_9 = c.red1
  vim.g.terminal_color_10 = c.green2
  vim.g.terminal_color_11 = c.yellow2
  vim.g.terminal_color_12 = c.blue2
  vim.g.terminal_color_13 = c.magenta1
  vim.g.terminal_color_14 = c.cyan2
  vim.g.terminal_color_15 = c.fg2

  -- highlighting for special characters
  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"
end

---Sets the active neovim theme based on the provided `colorscheme`
---@param theme util.theme.name
---@param bg? util.theme.mode
M.load = function(theme, bg)
  bg = bg or "dark"
  local t = vim.split(theme, "-")
  local path = N.dirs.palettes .. table.concat(t, "/")
  if not (vim.uv.fs_stat(vim.fs.joinpath(N.dirs.root, path .. ".lua")) or pcall(require, path)) then return end
  local _bg = vim.o.background
  if _bg ~= bg then vim.o.background = bg end
  if vim.g.colors_name then vim.cmd "highlight clear" end
  vim.g.colors_name = theme ---@type util.theme.name
  vim.g.ds_colors = require(path) ---@type util.theme.palette
  M.apply(theme, vim.g.ds_colors)
end

---Clears the neovim cache for all colorschemes in the colors directory
M.clear_cache = function()
  ds.fs.walk("colors", function(_, name, kind)
    if (kind == "file" or kind == "link") and name:match "%.lua$" then
      local theme = name:sub(1, -5)
      N.cache.clear(theme)
    end
  end)
end

return M
