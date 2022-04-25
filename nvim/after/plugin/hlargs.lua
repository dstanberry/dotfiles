-- verify hlargs is available
local ok, hlargs = pcall(require, "hlargs")
if not ok then
  return
end

local c = require("ui.theme").colors

hlargs.setup {
  -- color = "#ef9062",
  color = c.base16,
  excluded_filetypes = {},
  -- disable = function(lang, bufnr) -- If changed, `excluded_filetypes` will be ignored
  --   return vim.tbl_contains(opts.excluded_filetypes, lang)
  -- end,
  paint_arg_declarations = true,
  paint_arg_usages = true,
  hl_priority = 10000,
  excluded_argnames = {
    declarations = {},
    usages = {
      python = { "self", "cls" },
      lua = { "self" },
    },
  },
  performance = {
    parse_delay = 1,
    slow_parse_delay = 50,
    max_iterations = 400,
    max_concurrent_partial_parses = 30,
    debounce = {
      partial_parse = 3,
      partial_insert_mode = 100,
      total_parse = 700,
      slow_parse = 5000,
    },
  },
}
