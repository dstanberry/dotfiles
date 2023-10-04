local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("LuasnipChoiceNodePassive", { bold = true })

return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  keys = {
    {
      "<tab>",
      function()
        if require("luasnip").expand_or_locally_jumpable() then
          require("luasnip").expand_or_jump()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<tab>", true, true, true), "n", true)
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<s-tab>",
      function()
        if require("luasnip").in_snippet() and require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<s-tab>", true, true, true), "n", true)
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<c-d>",
      function()
        if require("luasnip").in_snippet() and require("luasnip").choice_active() then
          require("luasnip").change_choice(1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-d>", true, true, true), "n", true)
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<c-f>",
      function()
        if require("luasnip").in_snippet() and require("luasnip").choice_active() then
          require("luasnip").change_choice(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-d>", true, true, true), "n", true)
        end
      end,
      silent = true,
      mode = { "i", "s" },
    },
    {
      "<c-t>",
      function() require("remote.luasnip.util").dynamic_node_external_update(1) end,
      silent = true,
      mode = { "i", "s" },
    },
  },
  config = function()
    local luasnip = require "luasnip"
    local types = require "luasnip.util.types"

    luasnip.config.setup {
      keep_roots = true,
      link_roots = true,
      link_children = true,
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

    luasnip.filetype_extend("NeogitCommitMessage", { "gitcommit" })
    luasnip.filetype_extend("javascript.jsx", { "javascript" })
    luasnip.filetype_extend("javascriptreact", { "javascript" })
    luasnip.filetype_extend("typescript", { "javascript" })
    luasnip.filetype_extend("typescript.tsx", { "javascript" })
    luasnip.filetype_extend("typescriptreact", { "javascript" })

    require("luasnip.loaders.from_lua").lazy_load {
      paths = ("%s/lua/remote/luasnip/snippets/"):format(vim.fn.stdpath "config"),
    }
  end,
}
