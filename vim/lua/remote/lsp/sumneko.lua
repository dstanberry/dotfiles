---------------------------------------------------------------
-- => (sumneko) lua-language-server configuration
---------------------------------------------------------------
-- identify project root directory
local util = require 'lspconfig/util'

local root_files = {".config", ".git"}

local project_root = function(fname)
  return util.root_pattern(unpack(root_files))(fname) or
           util.path.dirname(fname)
end

return {
  diagnostics = {globals = {"vim"}},
  workspace = {library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true}},
  root_dir = project_root
}
