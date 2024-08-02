local M = {}

---@class util.theme table<util.theme_name,util.theme_palette>
M.themes = {}

M._initialized = false

--- Defines highlight groups using the provided color palette
---@param c util.theme_palette
M.apply = function(c)
  local root = "theme/groups"
  local groups = {}

  ds.walk(root, function(path, name, type)
    if (type == "file" or type == "link") and name:match "%.lua$" then
      local mod = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
      name = name:sub(1, -5)
      if mod:match "%." then name = mod:gsub("%.", "-") end
      for k, v in pairs(require(root:gsub("/", ".") .. "." .. mod).get(c)) do
        groups[k] = v
      end
    end
  end)

  ds.hl.set(groups)

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
---@param t util.theme_name
---@param b? util.theme_bg
M.load = function(t, b)
  b = b or "dark"
  if not M._initialized then
    M._initialized = true
    local root = "theme/palette"
    ds.walk(root, function(path, name, type)
      if (type == "file" or type == "link") and name:match "%.lua$" then
        local mod = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
        name = name:sub(1, -5)
        if mod:match "%." then name = mod:gsub("%.", "-") end
        M.themes[name] = require(root:gsub("/", ".") .. "." .. mod)
      end
    end)
  end
  if t and M.themes[t] then
    vim.cmd "highlight clear"
    vim.o.background = "dark"
    vim.g.colors_name = t ---@type util.theme_name
    vim.g.ds_colors = M.themes[t] ---@type util.theme_palette
    M.apply(vim.g.ds_colors)
  end
end

return M
