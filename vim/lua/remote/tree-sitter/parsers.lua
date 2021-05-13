---------------------------------------------------------------
-- => Tree-Sitter custam parsers
---------------------------------------------------------------
-- verify tree-sitter is available
local has_config, parser_config =
  pcall(require, 'nvim-treesitter.parsers')
if not has_config then
  return
end

parser_config.get_parser_configs().vim = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-viml",
    files = {"src/parser.c", "src/scanner.c"}
  },
  used_by = {'vifmrc', 'vimrc'}
}
