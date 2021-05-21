---------------------------------------------------------------
-- => nlua.nvim (sumneko) lua-language-server configuration
---------------------------------------------------------------
return {
  globals = {'vim'},
  library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true}
}
