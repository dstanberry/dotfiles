local zk = require("remote.lsp.servers.zk")

local M = {}

local executable = zk.get_executable_path()
local zk_notebook = zk.get_notebook_path()

local templates = {
  {
    ordinal = 1,
    label = "Daily team standup",
    directory = "vault/inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 2,
    label = "One-on-one",
    directory = "vault/inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 3,
    label = "Iteration retrospective meeting",
    directory = "vault/inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 4,
    label = "Backlog refinement meeting",
    directory = "vault/inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 5,
    label = "Feature replenishment meeting",
    directory = "vault/inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 6,
    label = "Literature Note",
    directory = "vault/literature",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 7,
    label = "Permanent Note",
    directory = "vault/permanent",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 8,
    label = "Fleeting Note",
    directory = "vault/journal",
    ask_for_title = true,
    prefix_date = false,
  },
}

M.create_template_reference = function()
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    return
  end

  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values
  local opts = require("telescope.themes").get_dropdown {}

  pickers.new(opts, {
    prompt_title = "",
    finder = finders.new_table {
      results = templates,
      entry_maker = function(entry)
        return {
          ordinal = entry.ordinal,
          display = entry.label,
          value = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local function on_complete(title)
          vim.cmd(string.format("cd %s", zk_notebook))
          local cmd = string.format(
            '%s new --no-input --title "%s" "%s" --print-path',
            executable,
            title,
            selection.value.directory
          )
          local file = vim.fn.system(cmd)
          file = file:gsub("^%s*(.-)%s*$", "%1")
          if vim.fn.filereadable(file) then
            local segments = vim.split(file, "/")
            local filename = segments[#segments]
            filename = filename:gsub(".md", "")
            vim.api.nvim_put({ string.format("[[%s]]", filename) }, "c", true, true)
          else
            vim.notify("File not found: " .. file, 2)
          end
        end
        if selection.value.ask_for_title then
          vim.ui.input({ prompt = "Title: " }, function(input)
            if input == nil or input == "" then
              return
            end
            on_complete(input)
          end)
        else
          on_complete(selection.value.label)
        end
      end)
      return true
    end,
  }):find()
end

M.create_note = function()
  vim.cmd(string.format("cd %s", zk_notebook))
  local cmd = ([[%s new --no-input "vault/journal" --print-path]]):format(executable)
  local file = vim.fn.system(cmd)
  file = file:gsub("^%s*(.-)%s*$", "%1")
  if vim.fn.filereadable(file) then
    vim.cmd(string.format("edit %s", file))
  end
end

M.get_executable_path = function()
  return executable
end

return M
