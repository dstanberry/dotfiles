local excludes = require "ui.excludes"
local icons = require "ui.icons"

return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim",
        "mfussenegger/nvim-dap",
      },
      event = "UIEnter",
      config = function()
        vim.opt.foldcolumn = "1"
        vim.opt.signcolumn = "number"
        local builtin = require "statuscol.builtin"
        require("statuscol").setup {
          -- ft_ignore = vim.tbl_deep_extend("keep", excludes.ft.stl_disabled, excludes.ft.wb_disabled),
          bt_ignore = excludes.bt.wb_disabled,
          relculright = true,
          segments = {
            { sign = { name = { "GitSigns" }, maxwidth = 1, colwidth = 1, auto = true }, click = "v:lua.ScSa" },
            -- { text = { "%s" }, click = "v:lua.ScSa" },
            {
              text = { " ", builtin.lnumfunc, " " },
              sign = { name = { ".*" }, maxwidth = 3, auto = true },
              click = "v:lua.ScLa",
            },
            { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          },
        }
      end,
    },
  },
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "ufo: open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "ufo: close all folds" },
    { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "ufo: peek content within fold" },
  },
  opts = {
    open_fold_hl_timeout = 0,
    preview = {
      win_config = {
        border = "none",
        maxheight = 20,
        winblend = 0,
        winhighlight = "Normal:NormalSB",
      },
    },
    enable_get_fold_virt_text = true,
    fold_virt_text_handler = function(virt_text, _, end_lnum, width, truncate, ctx)
      local result = {}
      local padding = ""
      local cur_width = 0
      local suffix_width = vim.api.nvim_strwidth(ctx.text)
      local target_width = width - suffix_width

      for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]
        local chunk_width = vim.api.nvim_strwidth(chunk_text)
        if target_width > cur_width + chunk_width then
          table.insert(result, chunk)
        else
          chunk_text = truncate(chunk_text, target_width - cur_width)
          local hl_group = chunk[2]
          table.insert(result, { chunk_text, hl_group })
          chunk_width = vim.api.nvim_strwidth(chunk_text)
          if cur_width + chunk_width < target_width then
            padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
          end
          break
        end
        cur_width = cur_width + chunk_width
      end
      local end_text = ctx.get_fold_virt_text(end_lnum)
      if end_text[1] and end_text[1][1] then end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "") end
      table.insert(result, { pad(icons.misc.Ellipses, "both"), "UfoFoldedEllipsis" })
      vim.list_extend(result, end_text)
      table.insert(result, { padding, "" })
      return result
    end,
    provider_selector = function(_, filetype)
      local ufo_ft_map = { dart = { "lsp", "treesitter" } }
      return ufo_ft_map[filetype] or { "treesitter", "indent" }
    end,
  },
}
