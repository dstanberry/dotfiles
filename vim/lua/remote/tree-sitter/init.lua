---------------------------------------------------------------
-- => Tree-Sitter Configuration
---------------------------------------------------------------
-- verify tree-sitter is available
local treesitter_config = pcall(require, 'nvim-treesitter')
if not treesitter_config then
	return
end

-- reload tree-sitter
local should_reload = false
if should_reload then
  RELOAD('nvim-treesitter')
end

-- option to disable extension
local enabled = true

-- set default options
require('nvim-treesitter.configs').setup {
	ensure_installed = { 'bash', 'jsonc', 'lua', 'python' },
	highlight = {
		enable = enabled,
		use_languagetree = false,
		disable = {""},
	},
	incremental_selection = {
		enable = enabled,
	},
}
