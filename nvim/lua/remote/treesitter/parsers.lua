-- verify tree-sitter is available
local ok, treesitter_parsers = pcall(require, "nvim-treesitter.parsers")
if not ok then
  return
end

treesitter_parsers.filetype_to_parsername.zsh = "bash"
