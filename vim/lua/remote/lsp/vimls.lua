---------------------------------------------------------------
-- => vim-language-server configuration
---------------------------------------------------------------
-- identify project root directory
local util = require 'lspconfig/util'

local root_files = {'.git', '.vimrc', 'init.vim', 'vimrc'}

local project_root = function(fname)
  return util.root_pattern(unpack(root_files))(fname) or
           util.path.dirname(fname)
end

return {vimruntime = vim.fn.expand('$VIMRUNTIME'), root_dir = project_root}
