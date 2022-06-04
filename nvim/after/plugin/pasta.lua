-- verify nvim-pasta is available
local ok, pasta = pcall(require, "pasta")
if not ok then
  return
end

local mappings = require "pasta.mappings"

-- vim.keymap.set("n", "p", mappings.p)
-- vim.keymap.set("n", "P", mappings.P)
--
-- pasta.setup {
--   converters = {},
--   next_key = vim.api.nvim_replace_termcodes("<c-n>", true, true, true),
--   prev_key = vim.api.nvim_replace_termcodes("<c-p>", true, true, true),
-- }
