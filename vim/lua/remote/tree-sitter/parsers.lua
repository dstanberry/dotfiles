---------------------------------------------------------------
-- => Tree-Sitter custam parsers
---------------------------------------------------------------
-- verify tree-sitter is available
local has_config, parser_config = pcall(require, 'nvim-treesitter.parsers')
if not has_config then
  return
end

-- add remote parsers (not available via nvim-treesitter)
parser_config.get_parser_configs().vim = {
  install_info = {
    url = "https://github.com/vigoux/tree-sitter-viml",
    files = {"src/parser.c", "src/scanner.c"}
  },
  used_by = {"vifmrc", "vimrc"}
}

-- helper function to load language scheme
local read_query = function(language, filename)
  local front = "/vim/lua/remote/tree-sitter/queries"
  local back = "/" .. language .. "/" .. filename .. ".scm"
  local path = os.getenv("XDG_CONFIG_HOME") .. front .. back
  return table.concat(vim.fn.readfile(vim.fn.expand(path)), "\n")
end

-- add local language schemes
local languages = {vim = {"highlights", "injections"}}

for lang, list in pairs(languages) do
  for _, scheme in ipairs(list) do
    require('vim.treesitter.query').set_query(lang, scheme,
                                              read_query(lang, scheme))
  end
end

-- vim.cmd [[
-- augroup treesitter_highlight
--   autocmd!
--   autocmd BufRead if &ft==? 'vim' | :TSBufDisable highlight
-- augroup END
-- ]]
