-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local types = require "luasnip.util.types"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("LuasnipChoiceNodePassive", { bold = true })

luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })

luasnip.filetype_extend("javascript.jsx", { "javascript" })
luasnip.filetype_extend("javascriptreact", { "javascript" })
luasnip.filetype_extend("typescript", { "javascript" })
luasnip.filetype_extend("typescript.tsx", { "javascript" })
luasnip.filetype_extend("typescriptreact", { "javascript" })

local M = {}

local meta = setmetatable({}, {
  __index = function(t, k)
    local val
    ok, val = pcall(require, string.format("remote.luasnip.%s", k))
    if M[k] then
      return M[k]
    elseif ok then
      rawset(t, k, val)
      return val
    end
  end,
})

M.setup = function()
  luasnip.config.setup {
    history = true,
    enable_autosnippets = true,
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "CursorHold,InsertLeave",
    delete_check_events = "TextChanged,InsertEnter",
    store_selection_keys = "<c-x>",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { pad(icons.misc.Layer, "both"), "Constant" } },
        },
      },
    },
  }

  require("luasnip.loaders.from_lua").lazy_load {
    paths = ("%s/lua/remote/luasnip/snippets/"):format(vim.fn.stdpath "config"),
  }
end

return meta
