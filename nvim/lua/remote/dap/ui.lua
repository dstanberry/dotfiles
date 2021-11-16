-- verify dap-ui is available
local ok, dap_ui = pcall(require, "dapui")
if not ok then
  return
end

dap_ui.setup {
  mappings = {
    expand = { "<cr>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    elements = {
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 0.25 },
    },
    size = 50,
    position = "left",
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom",
  },
  floating = {
    boder = "single",
    max_height = nil,
    max_width = nil,
    mappings = {
      close = { "q", "<esc>" },
    },
  },
  windows = { indent = 1 },
}
