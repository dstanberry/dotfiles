---------------------------------------------------------------
-- => Telescope Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

local map = require "util.map"

map.nnoremap("<leader><leader>", "<cmd>lua R('remote.telescope').project_files()<cr>")
map.nnoremap("<localleader><localleader>", "<cmd>lua R('remote.telescope').find_nvim()<cr>")
map.nnoremap("<leader>fb", "<cmd>lua R('remote.telescope').buffers()<cr>")
map.nnoremap("<leader>fe", "<cmd>lua R('remote.telescope').file_browser()<cr>")
map.nnoremap("<leader>ff", "<cmd>lua R('remote.telescope').current_buffer()<cr>")
map.nnoremap("<leader>fk", "<cmd>lua R('remote.telescope').help_tags()<cr>")
map.nnoremap("<leader>fp", "<cmd>lua R('remote.telescope').find_plugins()<cr>")
map.nnoremap("<leader>gg", "<cmd>lua R('remote.telescope').grep_string()<cr>")
