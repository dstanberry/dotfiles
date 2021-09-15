-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

local map = require "util.map"
local mod = require "util.modules"

map.nnoremap("<localleader><localleader>", function()
  mod.reload("remote.telescope").find_nvim()
end)
map.nnoremap("<leader><leader>", function()
  mod.reload("remote.telescope").project_files()
end)
map.nnoremap("<leader>fb", function()
  mod.reload("remote.telescope").buffers()
end)
map.nnoremap("<leader>fe", function()
  mod.reload("remote.telescope").file_browser()
end)
map.nnoremap("<leader>ff", function()
  mod.reload("remote.telescope").current_buffer()
end)
map.nnoremap("<leader>fg", function()
  mod.reload("remote.telescope").grep_string()
end)
map.nnoremap("<leader>fk", function()
  mod.reload("remote.telescope").help_tags()
end)
map.nnoremap("<leader>fl", function()
  mod.reload("remote.telescope").live_grep()
end)
map.nnoremap("<leader>fp", function()
  mod.reload("remote.telescope").find_plugins()
end)
