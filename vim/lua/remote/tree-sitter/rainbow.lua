---------------------------------------------------------------
-- => nvim-ts-rainbow
---------------------------------------------------------------
-- verify tree-sitter is available
local treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not treesitter_config then
  return
end

treesitter_configs.setup {
  rainbow = {
    enable = true
  }
}
