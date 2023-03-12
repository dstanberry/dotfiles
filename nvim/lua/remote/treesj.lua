return {
  "Wansmer/treesj",
  enabled = true,
  cmd = { "TSJSplit", "TSJJoin" },
  keys = {
    {"gJ", "<cmd>TSJSplit<cr>", desc = "treesj: split node under cursor"},
    {"gj", "<cmd>TSJJoin<cr>", desc = "treesj: join node under cursor"},
  },
  init = function()
    vim.keymap.set("n", "gS", ":TSJSplit<CR>", { silent = true })
    vim.keymap.set("n", "gJ", ":TSJJoin<CR>", { silent = true })
  end,
  opts = {
    use_default_keymaps = false,
    check_syntax_error = true,
    max_join_length = 200,
    cursor_behavior = "hold",
    notify = true,
  },
}
