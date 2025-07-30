return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  keys = function()
    local function handle_choice(direction, keys)
      local luasnip = require "luasnip"
      if luasnip.in_snippet() and luasnip.choice_active() then
        luasnip.change_choice(direction)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys or "", true, true, true), "n", true)
      end
    end

    return {
      { "<c-d>", function() handle_choice(1, "<c-d>") end, silent = true, mode = { "i", "s" } },
      { "<c-f>", function() handle_choice(-1, "<c-f>") end, silent = true, mode = { "i", "s" } },
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

    opts.ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { { ds.pad(ds.icons.misc.Layer, "both"), "Constant" } },
        },
      },
    }

    luasnip.config.setup(opts)
    luasnip.filetype_extend("javascriptreact", { "javascript" })
    luasnip.filetype_extend("typescript", { "javascript" })
    luasnip.filetype_extend("typescriptreact", { "javascript" })

    ds.snippet.expand = luasnip.lsp_expand
    ds.snippet.active = function(filter)
      filter = vim.tbl_deep_extend("force", { direction = 1 }, filter or {})
      return filter.direction == 1 and luasnip.expand_or_jumpable() or luasnip.jumpable(filter.direction)
    end
    ds.snippet.jump = function(direction)
      direction = direction or 1
      if direction == 1 then
        if luasnip.expand_or_locally_jumpable() then
          vim.schedule(function()
            local blink = package.loaded["blink.cmp"]
            luasnip.expand_or_jump()
            if blink then blink.hide() end
          end)
          return true
        end
      end
      if luasnip.jumpable(direction) then
        vim.schedule(function() luasnip.jump(direction) end)
        return true
      end
    end
    ds.snippet.stop = function()
      if luasnip.expand_or_jumpable() then
        luasnip.unlink_current()
        return true
      end
    end

    require("luasnip.loaders.from_lua").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "luasnip", "snippets") },
    }
  end,
}
