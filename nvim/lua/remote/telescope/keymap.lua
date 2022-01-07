local telescope = require "remote.telescope"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

vim.keymap.set("n", "<localleader><localleader>", telescope.find_nvim)
vim.keymap.set("n", "<leader><leader>", telescope.project_files)
vim.keymap.set("n", "<leader>f/", telescope.grep_last_search)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fe", telescope.file_browser)
vim.keymap.set("n", "<leader>ff", telescope.current_buffer)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fgg", telescope.rg.live_grep_with_shortcuts)
vim.keymap.set("n", "<leader>fk", telescope.help_tags)
vim.keymap.set("n", "<leader>fp", telescope.find_plugins)
vim.keymap.set("n", "<leader>ws", telescope.lsp.workspace_symbols)

vim.keymap.set("n", "<localleader>mm", function()
  local zk = require "remote.lsp.servers.zk"
  local zk_notebook = zk.get_notebook_path()
  local opts
  opts = {
    prompt_title = [[\ Notes /]],
    cwd = zk_notebook,
    attach_mappings = function(bufnr, map)
      actions.select_default:replace(function()
        actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        local file = vim.fn.expand(string.format("%s/%s", zk_notebook, selection[1]))
        vim.cmd(string.format(
          [[
            tabnew %s
            tcd %s
          ]],
          file,
          zk_notebook
        ))
      end)
      map("i", "<cr>", function()
        actions.select_default(bufnr)
      end)
      map("i", "-", function()
        local selection = action_state.get_selected_entry()
        dump(selection)
      end)
      return true
    end,
  }
  telescope.find_files(opts)
end)
