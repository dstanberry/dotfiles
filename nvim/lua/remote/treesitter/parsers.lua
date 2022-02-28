-- verify tree-sitter is available
local ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not ok then
  return
end

local ft_to_lang = parsers.ft_to_lang
require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  end
  return ft_to_lang(ft)
end
