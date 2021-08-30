---------------------------------------------------------------
-- => tmux.nvim configuration
---------------------------------------------------------------
-- verify tmux is available
local ok, tmux = pcall(require, "tmux")
if not ok then
  return
end

tmux.setup {
  copy_sync = {
    enable = false,
  },
  navigation = {
    cycle_navigation = true,
    enable_default_keybindings = true,
    persist_zoom = false,
  },
  resize = {
    enable_default_keybindings = true,
    resize_step_x = 1,
    resize_step_y = 1,
  },
}
