---------------------------------------------------------------
-- => Tree-Sitter Configuration
---------------------------------------------------------------
-- verify tree-sitter is available
local has_treesitter, treesitter_configs =
  pcall(require, 'nvim-treesitter.configs')
if not has_treesitter then
  return
end

-- option to disable extension
local enabled = true

-- set default options
treesitter_configs.setup {
  ensure_installed = {
    'bash', 'c', 'c_sharp', 'comment', 'cpp', 'css', 'html', 'javascript',
    'jsdoc', 'jsonc', 'lua', -- [[ 'markdown', ]]
    'python', 'query', 'regex', 'ruby', 'vim', 'yaml'
  },
  highlight = {enable = enabled, use_languagetree = false, disable = {'vim'}},
  incremental_selection = {enable = enabled}
}
