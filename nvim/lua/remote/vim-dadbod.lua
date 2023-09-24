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
  dependencies = {
    "kristijanhusak/vim-dadbod-completion",
    "tpope/vim-dadbod",
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
  keys = {
    { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
  end,
  config = function()
    if require("lazy.core.config").plugins["nvim-cmp"] ~= nil then
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("db-completion", { clear = true }),
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          ---@diagnostic disable-next-line: missing-fields
          require("cmp").setup.buffer {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "luasnip" },
              { name = "path" },
              { name = "buffer", keyword_length = 5, max_item_count = 5 },
            },
          }
        end,
      })
    end
  end,
}
