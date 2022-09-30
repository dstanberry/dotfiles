-- verify toggleterm is availalbe
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup {
  direction = "float",
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
  hide_numbers = true,
  autochdir = true,
  highlights = {
    NormalFloat = { link = "Normal" },
    FloatBorder = { link = "FloatBorder" },
  },
  float_opts = {
    border = "single",
    winblend = 0,
  },
  winbar = {
    enabled = false,
  },
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  close_on_exit = true,
}

local float
float = Terminal:new {
  direction = "float",
  on_open = function(term)
    vim.keymap.set({ "i", "n", "t" }, "<a-t>", function()
      float:toggle()
    end, { buffer = term.bufnr })
  end,
}

vim.keymap.set({ "i", "n" }, "<a-t>", function()
  float:toggle()
end)
