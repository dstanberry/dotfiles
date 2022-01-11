-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local types = require "luasnip.util.types"
local groups = require "ui.theme.groups"

groups.new("LuasnipChoiceNodePassive", { guifg = nil, guibg = nil, gui = "bold", guisp = nil })

local M = setmetatable({}, {
  __index = function(t, k)
    if k == "extras" then
      local val = require "luasnip.extras"
      rawset(t, k, val)
      return val
    end
    if k == "extras_fmt" then
      local val = require "luasnip.extras.fmt"
      rawset(t, k, val)
      return val
    end
    return luasnip[k]
  end,
})

M.setup = function()
  luasnip.config.setup {
    history = true,
    enable_autosnippets = true,
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "CursorHold",
    delete_check_events = "TextChanged",
    store_selection_keys = "<c-s>",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "﬘ ", "Constant" } },
        },
      },
      [types.insertNode] = {
        passive = {
          hl_group = "Bold",
        },
      },
    },
  }

  local snippets = vim.api.nvim_get_runtime_file("lua/remote/luasnip/snippets/*.lua", true)
  for _, file in ipairs(snippets) do
    local fname
    if has "win32" then
      fname = (file):match "^.+\\(.+)$"
    else
      fname = (file):match "^.+/(.+)$"
    end
    local mod = fname:sub(1, -5)
    reload(("remote.luasnip.snippets.%s"):format(mod))
    local config = require(("remote.luasnip.snippets.%s"):format(mod)).config
    if type(config) == "table" then
      for k, v in pairs(config) do
        luasnip.snippets[k] = v
      end
    end
  end
end

return M
