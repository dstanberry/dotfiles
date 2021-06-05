---------------------------------------------------------------
-- => nlua.nvim (sumneko) lua-language-server configuration
---------------------------------------------------------------
local util = require('lspconfig.util')

local root_files = {".vimrc", "init.lua", "init.vim", "vimrc"}

-- identify project root directory
local project_root = function(fname)
  return util.find_git_ancestor(fname) or
           util.root_pattern(unpack(root_files))(fname) or
           util.path.dirname(fname)
end
return {
  globals = {"vim"},
  root_dir = project_root,
  library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true}
}
