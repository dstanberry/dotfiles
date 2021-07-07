---------------------------------------------------------------
-- => Tree-Sitter custam parsers
---------------------------------------------------------------
-- verify tree-sitter is available
local has_config, parsers = pcall(require, "nvim-treesitter.parsers")
if not has_config then
  return
end

-- add remote parsers (not available via nvim-treesitter)
local config = parsers.get_parser_configs()
config.vim = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-viml",
    files = { "src/parser.c", "src/scanner.c" },
  },
  used_by = { "vifmrc", "vimrc" },
}

vim.cmd [[
augroup treesitter_highlight
  autocmd!
  autocmd BufEnter,BufRead vimrc TSBufDisable highlight
augroup END
]]
