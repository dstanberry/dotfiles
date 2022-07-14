local telescope = require "remote.telescope"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local previewers = require "telescope.previewers"
local putils = require "telescope.previewers.utils"

local zk = require "remote.lsp.servers.zk"
local zku = require "zk.util"

local M = {}

local templates = {
  {
    label = "Permanent note",
    directory = "resources",
    ask_for_title = true,
  },
  {
    label = "Team standup",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Backlog refinement meeting",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Feature replenishment meeting",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Other meeting",
    directory = "inbox",
    ask_for_title = true,
  },
  {
    label = "One-on-one",
    directory = "journal",
    ask_for_title = false,
  },
  {
    label = "Literature note",
    directory = "journal",
    ask_for_title = true,
  },
  {
    label = "Other note",
    directory = "journal",
    ask_for_title = false,
  },
}

M.find_notes = function()
  local notebook_path = zku.resolve_notebook_path(0)
  local notebook_root = zku.notebook_root(notebook_path)
  local opts
  opts = {
    prompt_title = ("Notes (%s)"):format(notebook_root),
    cwd = notebook_root,
    attach_mappings = function(bufnr, map)
      actions.select_default:replace(function()
        actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        local file = vim.fn.expand(string.format("%s/%s", notebook_root, selection[1]))
        vim.cmd(string.format("edit %s", file))
      end)
      map("i", "<cr>", function()
        actions.select_default(bufnr)
      end)
      return true
    end,
  }
  if notebook_root then
    telescope.find_files(themes.get_ivy(opts))
  else
    vim.notify("Zk notebook not found!", vim.log.levels.ERROR)
  end
end

M.create_note = function()
  telescope.pickers.create("dropdown", templates, {
    callback = function(selection)
      local opts = {}
      opts.prompt_title = "Notes (create from template)"
      opts.dir = selection.value.directory
      if selection.value.ask_for_title then
        opts.title = vim.fn.input "Title: "
        if opts.title == "" or opts.title == nil then
          return
        end
      else
        opts.title = selection.value.label
      end
      zk.new(opts)
    end,
  })
end

M.create_reference_with_title = function()
  local location = zku.get_lsp_location_from_selection()
  local chunk = zku.get_text_in_range(location.range)
  assert(chunk ~= nil, "No selected text")
  telescope.pickers.create("dropdown", templates, {
    callback = function(selection)
      local opts = {}
      opts.prompt_title = "Notes (create reference from template)"
      opts.dir = selection.value.directory
      zk.new(vim.tbl_extend("force", { insertLinkAtLocation = location, title = chunk }, opts or {}))
    end,
  })
end

M.create_reference_with_content = function()
  local location = zku.get_lsp_location_from_selection()
  local chunk = zku.get_text_in_range(location.range)
  assert(chunk ~= nil, "No selected text")
  telescope.pickers.create("dropdown", templates, {
    callback = function(selection)
      local opts = {}
      opts.prompt_title = "Notes (create reference from template)"
      opts.dir = selection.value.directory
      if selection.value.ask_for_title then
        opts.title = vim.fn.input "Title: "
        if opts.title == "" or opts.title == nil then
          return
        end
      else
        opts.title = selection.value.label
      end
      zk.new(vim.tbl_extend("force", { insertLinkAtLocation = location, content = chunk }, opts or {}))
    end,
  })
end

return M
