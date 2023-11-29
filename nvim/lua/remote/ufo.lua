local icons = require "ui.icons"

return {
  "kevinhwang91/nvim-ufo",
  event = { "LazyFile", "VeryLazy" },
  dependencies = { "kevinhwang91/promise-async" },
  enabled = false,
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "ufo: open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "ufo: close all folds" },
    { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "ufo: peek content within fold" },
  },
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.signcolumn = "number"
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    open_fold_hl_timeout = 150,
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
    provider_selector = function() return { "treesitter", "indent" } end,
  },
}
