---------------------------------------------------------------
-- => Telescope Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

-- define keymaps
local mod = "R('remote.telescope')."

MAP("n", "<leader><leader>", mod .. "search_cwd()")
MAP("n", "<localleader><localleader>", mod .. "search_neovim()")
MAP("n", "<leader>fb", mod .. "search_buffers()")
MAP("n", "<leader>fe", mod .. "file_browser()")
MAP("n", "<leader>ff", mod .. "current_buffer()")
MAP("n", "<leader>fh", mod .. "help_tags()")
MAP("n", "<leader>fp", mod .. "installed_plugins()")
MAP("n", "<leader>fr", mod .. "search_git_repo()")
MAP("n", "<leader>gf", mod .. "grep_cursor()")
MAP("n", "<leader>gg", mod .. "grep_cwd()")
