return {
  "smjonas/inc-rename.nvim",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    { "g/", function() return ":IncRename " .. vim.fn.expand "<cword>" end, expr = true },
  },
  opts = {
    hl_group = "Substitute",
  },
}
