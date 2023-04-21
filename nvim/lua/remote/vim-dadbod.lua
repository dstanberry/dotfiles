local ftplugin = vim.api.nvim_create_augroup("hl_dadbod", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ftplugin,
  pattern = { "dbout", "dbui" },
  callback = function()
    vim.opt_local.winhighlight = "Normal:NormalSB"
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

return {
  "kristijanhusak/vim-dadbod-ui",
  event = "VeryLazy",
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
