---------------------------------------------------------------
-- => nvim-compe keymaps
---------------------------------------------------------------
-- verify nvim-compe is available
if not pcall(require, "compe") then
  return
end

local map = require "util.map"

map.inoremap("<cr>", "compe#confirm('<cr>')", { expr = true })
map.inoremap("<esc>", "compe#close('<esc>')", { expr = true })
map.inoremap("<c-space>", "compe#complete()", { expr = true })
