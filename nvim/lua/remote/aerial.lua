-- verify aerial is available
local ok, aerial = pcall(require,"aerial")
if not ok then
  return
end

local icons = require "ui.icons"

aerial.setup {
  on_attach = function(bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "\\s", "<Cmd>AerialToggle!<CR>", opts)
  end,
  backends = { "lsp", "treesitter", "markdown" },
  close_behavior = "auto",
  min_width = 40,
  max_width = 40,
  show_guides = true,
  default_direction = "right",
  icons = icons
}
