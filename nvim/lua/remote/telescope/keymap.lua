-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

local util = require "util"
local map = require "util.map"

map.nnoremap("<localleader><localleader>", function()
  util.reload("remote.telescope").find_nvim()
end)
map.nnoremap("<leader><leader>", function()
  util.reload("remote.telescope").project_files()
end)
map.nnoremap("<leader>fb", function()
  util.reload("remote.telescope").buffers()
end)
map.nnoremap("<leader>fe", function()
  util.reload("remote.telescope").file_browser()
end)
map.nnoremap("<leader>ff", function()
  util.reload("remote.telescope").current_buffer()
end)
map.nnoremap("<leader>fg", function()
  util.reload("remote.telescope").grep_string()
end)
map.nnoremap("<leader>fgg", function()
  util.reload("remote.telescope").live_grep()
end)
map.nnoremap("<leader>fk", function()
  util.reload("remote.telescope").help_tags()
end)
map.nnoremap("<leader>fn", function()
  util.reload("remote.telescope").find_files { cwd = vim.env.hash_n }
end)
map.nnoremap("<leader>fp", function()
  util.reload("remote.telescope").find_plugins()
end)
