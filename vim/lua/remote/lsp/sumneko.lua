---------------------------------------------------------------
-- => (sumneko) lua-language-server configuration
---------------------------------------------------------------
return {
  diagnostics = {globals = {"vim"}},
  workspace = {library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true}}
}
