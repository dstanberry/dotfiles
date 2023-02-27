return {
  "smjonas/inc-rename.nvim",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    -- replaces lsp rename keymap in |remote.lsp.handlers|
    -- { "g/", function() return ":IncRename " .. vim.fn.expand "<cword>" end, expr = true, desc = "inc-rename: lsp rename" },
  },
  opts = {
    hl_group = "Substitute",
  },
}
