---------------------------------------------------------------
-- => Telescope Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

local util = require "util"

util.nnoremap("<leader><leader>", "<cmd>lua R('remote.telescope').project_files()<cr>")
util.nnoremap("<localleader><localleader>", "<cmd>lua R('remote.telescope').find_nvim()<cr>")
util.nnoremap("<leader>fb", "<cmd>lua R('remote.telescope').buffers()<cr>")
util.nnoremap("<leader>fe", "<cmd>lua R('remote.telescope').file_browser()<cr>")
util.nnoremap("<leader>ff", "<cmd>lua R('remote.telescope').current_buffer()<cr>")
util.nnoremap("<leader>fk", "<cmd>lua R('remote.telescope').help_tags()<cr>")
util.nnoremap("<leader>fp", "<cmd>lua R('remote.telescope').find_plugins()<cr>")
util.nnoremap("<leader>gg", "<cmd>lua R('remote.telescope').grep_string()<cr>")
