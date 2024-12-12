return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  keys = function()
    local fallback = function(key)
      local keycode = vim.api.nvim_replace_termcodes(key or "", true, true, true)
      vim.api.nvim_feedkeys(keycode, "i", true)
    end

    local _next_jump = function()
      if require("luasnip").expand_or_locally_jumpable() then
        require("luasnip").expand_or_jump()
        local blink = package.loaded["blink.cmp"]
        if blink then blink.hide() end
        return
      end
      fallback "<tab>"
    end

    local _previous_jump = function()
      if require("luasnip").in_snippet() and require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
        return
      end
      fallback "<s-tab>"
    end

    local _next_choice = function()
      if require("luasnip").in_snippet() and require("luasnip").choice_active() then
        require("luasnip").change_choice(1)
        return
      end
      fallback "<c-d>"
    end

    local _previous_choice = function()
      if require("luasnip").in_snippet() and require("luasnip").choice_active() then
        require("luasnip").change_choice(-1)
        return
      end
      fallback "<c-f>"
    end

    return {
      { "<tab>", _next_jump, silent = true, mode = { "i", "s" } },
      { "<s-tab>", _previous_jump, silent = true, mode = { "i", "s" } },
      { "<c-d>", _next_choice, silent = true, mode = { "i", "s" } },
      { "<c-f>", _previous_choice, silent = true, mode = { "i", "s" } },
    }
  end,
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
            virt_text = { { ds.pad(ds.icons.misc.Layer, "both"), "Constant" } },
          },
        },
      },
    }

    luasnip.filetype_extend("javascript.jsx", { "javascript" })
    luasnip.filetype_extend("javascriptreact", { "javascript" })
    luasnip.filetype_extend("typescript", { "javascript" })
    luasnip.filetype_extend("typescript.tsx", { "javascript" })
    luasnip.filetype_extend("typescriptreact", { "javascript" })

    require("luasnip.loaders.from_lua").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "luasnip", "snippets") },
    }
  end,
}
