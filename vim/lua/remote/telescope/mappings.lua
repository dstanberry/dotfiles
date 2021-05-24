---------------------------------------------------------------
-- => Telescope Mappings
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, 'telescope') then
  return
end

ArgsMap = ArgsMap or {}

-- helper function to set keymaps and include additional options
local set_keymap = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  ArgsMap[map_key] = options or {}
  local mode = "n"
  local rhs = string.format(
                "<cmd>lua R('remote.telescope')['%s'](ArgsMap['%s'])<cr>", f,
                map_key)
  local map_options = {noremap = true, silent = true}
  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

-- define keymaps
set_keymap("<leader><leader>", "search_cwd")
set_keymap("<leader>fb", "search_buffers")
set_keymap("<leader>fd", "search_dotfiles")
set_keymap("<leader>fe", "file_browser")
set_keymap("<leader>ff", "current_buffer")
set_keymap("<leader>fh", "help_tags")
set_keymap("<leader>fp", "installed_plugins")
set_keymap("<leader>fr", "search_git_repo")
set_keymap("<leader>gf", "grep_cursor")
set_keymap("<leader>gg", "grep_cwd")
