-- verify dap-ui is available
local ok, ui = pcall(require, "dapui")
if not ok then
  return
end

ui.setup {
  mappings = {
    expand = { "<cr>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    open_on_start = true,
    elements = {
      { id = "scopes", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 0.25 },
    },
    width = 50,
    position = "left",
  },
  tray = {
    open_on_start = true,
    elements = { "repl" },
    height = 10,
    position = "bottom",
  },
  floating = {
    max_height = nil,
    max_width = nil,
    mappings = {
      close = { "q", "<esc>" },
    },
  },
  windows = { indent = 1 },
}
