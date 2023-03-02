return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  lazy = true,
  dependencies = { "folke/twilight.nvim" },
  opts = {
    window = {
      options = {
        signcolumn = "yes",
        number = true,
        relativenumber = true,
        cursorline = true,
        cursorcolumn = false,
        foldcolumn = "0",
        list = true,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      twilight = { enabled = true },
      tmux = { enabled = false },
      kitty = {
        enabled = true,
        font = "+4",
      },
    },
    on_close = function() vim.cmd.doautocmd "BufWinEnter" end,
  },
}
