return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
  keys = {
    { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_show_database_icon = 1
  end,
}
