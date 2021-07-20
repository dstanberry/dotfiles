---------------------------------------------------------------
-- => Telescope Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

local util = require "util"

util.nnoremap("<leader><leader>", "<cmd>lua R('remote.telescope').search_cwd()<cr>")
util.nnoremap("<localleader><localleader>", "<cmd>lua R('remote.telescope').search_neovim()<cr>")
util.nnoremap("<leader>fb", "<cmd>lua R('remote.telescope').search_buffers()<cr>")
util.nnoremap("<leader>fe", "<cmd>lua R('remote.telescope').file_browser()<cr>")
util.nnoremap("<leader>ff", "<cmd>lua R('remote.telescope').current_buffer()<cr>")
util.nnoremap("<leader>fh", "<cmd>lua R('remote.telescope').help_tags()<cr>")
util.nnoremap("<leader>fp", "<cmd>lua R('remote.telescope').installed_plugins()<cr>")
util.nnoremap("<leader>fr", "<cmd>lua R('remote.telescope').search_git_repo()<cr>")
util.nnoremap("<leader>gf", "<cmd>lua R('remote.telescope').grep_cursor()<cr>")
util.nnoremap("<leader>gg", "<cmd>lua R('remote.telescope').grep_cwd()<cr>")
