return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = "tpope/vim-dadbod",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
  keys = {
    { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
  end,
}
