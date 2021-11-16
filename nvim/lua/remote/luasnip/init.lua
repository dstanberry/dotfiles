-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local M = {}

local types = require "luasnip.util.types"

luasnip.config.setup {
  history = true,
  enable_autosnippets = true,
  updateevents = "InsertLeave",
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

local snippets = {
  "_default",
  "lua",
}

for _, snippet in ipairs(snippets) do
  local config = require(("remote.luasnip.snippets.%s"):format(snippet)).config
  if type(config) == "table" then
    for k, v in pairs(config) do
      luasnip.snippets[k] = v
    end
  end
end

return M
