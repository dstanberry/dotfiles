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
    store_selection_keys = "<c-x>",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "﬘ ", "Constant" } },
        },
      },
    },
  }

  require("luasnip.loaders.from_lua").load {
    paths = ("%s/lua/remote/luasnip/snippets/"):format(vim.fn.stdpath "config"),
  }
end

return M
