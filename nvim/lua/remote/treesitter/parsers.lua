-- verify tree-sitter is available
local ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not ok then
  return
end

local util = require "util"

local config = parsers.get_parser_configs()
config.vim.used_by = { "vifm", "vifmrc", "vimrc" }

local filetypes = vim.tbl_map(function(ft)
  local configs = parsers.get_parser_configs()
  return configs[ft].filetype or ft
end, parsers.available_parsers())

util.define_augroup {
  name = "treesitter_foldexpr",
  clear = true,
  autocmds = {
    {
      event = "Filetype",
      pattern = filetypes,
      -- callback = function()
      --   vim.wo.foldmethod = "expr"
      --   vim.wo.foldenable = false
      --   vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
      -- end,
      command = "setlocal nofoldenable foldmethod=expr foldexpr=nvim_treesitter#foldexpr()",
    },
  },
}
