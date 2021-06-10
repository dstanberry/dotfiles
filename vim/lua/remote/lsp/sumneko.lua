---------------------------------------------------------------
-- => nlua.nvim (sumneko) lua-language-server configuration
---------------------------------------------------------------
local util = require('lspconfig.util')

local root_dirs = {"nvim", "vim"}

-- identify project root directory
local project_root = function(fname)
  return util.find_git_ancestor(fname) or
           util.root_pattern(unpack(root_dirs))(fname) or
           util.path.dirname(fname)
end

return {
  globals = {"vim"},
  root_dir = project_root,
  library = {
    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
  }
}
