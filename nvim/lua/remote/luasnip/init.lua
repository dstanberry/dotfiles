return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  keys = function()
    local actions = require "remote.luasnip.actions"
    return {
      { "<tab>", function() actions.jump_to_next "<tab>" end, silent = true, mode = { "i", "s" } },
      { "<s-tab>", function() actions.jump_to_previous "<c-d>" end, silent = true, mode = { "i", "s" } },
      { "<c-d>", function() actions.next_choice "<c-d>" end, silent = true, mode = { "i", "s" } },
      { "<c-f>", function() actions.previous_choice "<c-f>" end, silent = true, mode = { "i", "s" } },
    }
  end,
  opts = {
    keep_roots = true,
    link_roots = true,
    link_children = true,
    enable_autosnippets = true,
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "CursorHold,InsertLeave",
    delete_check_events = "TextChanged,InsertEnter",
    store_selection_keys = "<c-x>",
  },
  config = function(_, opts)
    local luasnip = require "luasnip"
    local i = require("luasnip.util.types").choiceNode
    opts.ext_opts = {
      [i] = {
        active = {
          virt_text = { { ds.pad(ds.icons.misc.Layer, "both"), "Constant" } },
        },
      },
    }
    luasnip.config.setup(opts)

    luasnip.filetype_extend("javascriptreact", { "javascript" })
    luasnip.filetype_extend("typescript", { "javascript" })
    luasnip.filetype_extend("typescriptreact", { "javascript" })

    require("luasnip.loaders.from_lua").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "luasnip", "snippets") },
    }
  end,
}
