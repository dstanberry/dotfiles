---------------------------------------------------------------
-- => zen-mode configuration
---------------------------------------------------------------
-- verify zen-mode is available
local has_zen, zen = pcall(require, "zen")
if not has_zen then
  return
end

-- zen-mode setup
zen.setup {
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
  on_close = function()
    vim.cmd "doautocmd BufWinEnter"
  end,
}
