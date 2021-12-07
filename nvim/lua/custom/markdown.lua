-- verify telescope is available
local ok, _ = pcall(require, "telescope")
if not ok then
  return
end

local telescope = require "remote.telescope"
local pickers = telescope.pickers

local zk = require "remote.lsp.servers.zk"

local M = {}

local executable = zk.get_executable_path()
local zk_notebook = zk.get_notebook_path()

local types = {
  {
    ordinal = 1,
    label = "Meeting Note",
    directory = "vault/inbox",
  },
  {
    ordinal = 2,
    label = "Journal Entry",
    directory = "vault/journal",
  },
  {
    ordinal = 3,
    label = "Literature Note",
    directory = "vault/literature",
  },
  {
    ordinal = 4,
    label = "Permanent Note",
    directory = "vault/permanent",
  },
}

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

local prepare_window = function()
  vim.cmd(string.format(
    [[
      tabnew
      tcd %s
    ]],
    zk_notebook
  ))
end

M.create_template_reference = function()
  pickers.create_dropdown(templates, {
    callback = function(selection)
      local title = ""
      if selection.value.ask_for_title then
        title = vim.fn.input "Title: "
        if title == "" then
          return
        end
      else
        title = selection.value.label
      end
      prepare_window()
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
    end,
  })
end

M.create_note = function()
  pickers.create_dropdown(types, {
    callback = function(selection)
      prepare_window()
      local cmd = ([[%s new --no-input "%s" --print-path]]):format(executable, selection.value.directory)
      local file = vim.fn.system(cmd)
      file = file:gsub("^%s*(.-)%s*$", "%1")
      if vim.fn.filereadable(file) then
        vim.cmd(string.format("edit %s", file))
      end
    end,
  })
end

return M
