---------------------------------------------------------------
-- => tmux.nvim configuration
---------------------------------------------------------------
-- check if available
local ok, tmux = pcall(require, "tmux")
if not ok then
  return
end

-- default options
tmux.setup {
  copy_sync = {
    enable = true,
  },
  navigation = {
    enable_default_keybindings = true,
  },
  resize = {
    enable_default_keybindings = true,
  },
}
