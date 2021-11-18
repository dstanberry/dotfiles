-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local types = require "luasnip.util.types"

local M = setmetatable({}, {
  __index = function(t, k)
    if k == "extras" then
      local val = require "luasnip.extras"
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
    store_selection_keys = "<tab>",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "﬘ ", "Constant" } },
        },
      },
    },
  }

  local snippets = vim.api.nvim_get_runtime_file("lua/remote/luasnip/snippets/*.lua", true)
  for _, file in ipairs(snippets) do
    local fname = (file):match "^.+/(.+)$"
    local mod = fname:sub(1, -5)
    local config = require(("remote.luasnip.snippets.%s"):format(mod)).config
    if type(config) == "table" then
      for k, v in pairs(config) do
        luasnip.snippets[k] = v
      end
    end
  end
end

return M
