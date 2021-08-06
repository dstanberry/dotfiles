---------------------------------------------------------------
-- => nvim-compe keymaps
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, "compe") then
  return
end

local mamp = require "util.map"

mamp.inoremap("<cr>", "compe#confirm('<cr>')", { expr = true })
mamp.inoremap("<esc>", "compe#close('<esc>')", { expr = true })
mamp.inoremap("<c-space>", "compe#complete()", { expr = true })
