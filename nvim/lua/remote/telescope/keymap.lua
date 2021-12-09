local telescope = require "remote.telescope"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local util = require "util"
local nnoremap = util.map.nnoremap

nnoremap("<localleader><localleader>", function()
  telescope.find_nvim()
end)
nnoremap("<leader><leader>", function()
  telescope.project_files()
end)
nnoremap("<leader>f/", function()
  telescope.grep_last_search()
end)
nnoremap("<leader>fb", function()
  telescope.buffers()
end)
nnoremap("<leader>fe", function()
  telescope.file_browser()
end)
nnoremap("<leader>ff", function()
  telescope.current_buffer()
end)
nnoremap("<leader>fg", function()
  telescope.live_grep()
end)
nnoremap("<leader>fgg", function()
  telescope.rg.live_grep_with_shortcuts()
end)
nnoremap("<leader>fk", function()
  telescope.help_tags()
end)
nnoremap("<leader>fp", function()
  telescope.find_plugins()
end)
nnoremap("<leader>ws", function()
  telescope.lsp.workspace_symbols()
end)

nnoremap("<localleader>mm", function()
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
