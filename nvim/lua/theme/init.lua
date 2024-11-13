local M = {}

local N = {
  cache = {},
  dirs = {
    groups = "/theme/groups/",
    palettes = "/theme/palette/",
    root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h"),
  },
  groups = {},
}

---@param theme util.theme.name
N.cache.file = function(theme) return vim.fn.stdpath "cache" .. "/colorscheme-" .. theme .. ".json" end

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

N.cache.clear = function()
  for _, style in ipairs { "kdark", "catppuccin-frappe", "catppuccin-mocha" } do
    vim.uv.fs_unlink(N.cache.file(style))
  end
end

--- Defines highlight groups using the provided color palette
---@param theme util.theme.name
---@param c util.theme.palette
M.apply = function(theme, c)
  ds.walk(N.dirs.root .. N.dirs.groups, function(path, name, type)
    if (type == "file" or type == "link") and name:match "%.lua$" then
      name = path:match(N.dirs.root .. N.dirs.groups .. "/(.*)"):sub(1, -5):gsub("/", ".")
      table.insert(N.groups, name)
    end
  end)

  local cache = N.cache.read(theme)
  local inputs = { colors = c, plugins = N.groups }
  local g = cache and vim.deep_equal(inputs, cache.inputs) and cache.groups

  if not g then
    g = {}
    for _, mod in ipairs(N.groups) do
      local ret = loadfile(N.dirs.root .. N.dirs.groups .. mod .. ".lua")()
      for k, v in pairs(ret.get(c)) do
        g[k] = v
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
  if not vim.uv.fs_stat(N.dirs.root .. path .. ".lua") then return end
  local _bg = vim.o.background
  if _bg ~= bg then vim.o.background = bg end
  if vim.g.colors_name then vim.cmd "highlight clear" end
  vim.g.colors_name = theme ---@type util.theme.name
  vim.g.ds_colors = require(path) ---@type util.theme.palette
  M.apply(theme, vim.g.ds_colors)
end

return M
