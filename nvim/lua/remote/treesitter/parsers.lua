-- verify tree-sitter is available
local ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not ok then
  return
end

local config = parsers.get_parser_configs()
config.vim.used_by = { "vifm", "vifmrc", "vimrc" }
