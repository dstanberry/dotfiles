---------------------------------------------------------------
-- => Tree-Sitter custam parsers
---------------------------------------------------------------
-- verify tree-sitter is available
local ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not ok then
  return
end

-- add remote parsers (not available via nvim-treesitter)
local config = parsers.get_parser_configs()
config.vim = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-viml",
    files = { "src/parser.c", "src/scanner.c" },
  },
  used_by = { "vifm", "vifmrc", "vimrc" },
}
