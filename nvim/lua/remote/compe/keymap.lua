---------------------------------------------------------------
-- => nvim-compe keymaps
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, "compe") then
  return
end

local util = require "util"

util.inoremap("<cr>", "compe#confirm('<cr>')", { expr = true })
util.inoremap("<esc>", "compe#close('<esc>')", { expr = true })
util.inoremap("<c-x>", "compe#complete()", { expr = true })
