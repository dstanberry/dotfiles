local telescope = require "telescope"
local telescope_actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local telescope_builtin = require "telescope.builtin"
local telescope_themes = require "telescope.themes"

local telescope_pickers = require "remote.telescope.custom.pickers"

local zk = require "zk"
local zku = require "zk.util"

local util = require "util"

local templates = {
  {
    label = "Team sync meeting",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Generic meeting",
    directory = "inbox",
    ask_for_title = true,
  },
  {
    label = "Literature note",
    directory = "resources",
    ask_for_title = true,
  },
  {
    label = "Other note",
    directory = "journal",
    ask_for_title = false,
  },
}

pcall(telescope.load_extension, "zk")

local M = {}

M.edit_with = function(opts, picker_options)
  return function(options)
    options = vim.tbl_extend("force", opts, options or {})
    picker_options = vim.tbl_extend("force", picker_options, {
      telescope = telescope_themes.get_ivy {},
    })
    zk.edit(options, picker_options)
  end
end

M.find_notes = function()
  local notebook_path = zku.resolve_notebook_path(0)
  local notebook_root = zku.notebook_root(notebook_path)
  local opts
  opts = {
    prompt_title = ("Notes (%s)"):format(notebook_root),
    cwd = notebook_root,
    attach_mappings = function(bufnr, map)
      telescope_actions.select_default:replace(function()
        telescope_actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        local file = vim.fn.expand(string.format("%s/%s", notebook_root, selection[1]))
        vim.cmd.edit(file)
      end)
      map("i", "<cr>", function() telescope_actions.select_default(bufnr) end)
      return true
    end,
  }
  if notebook_root then
    telescope_builtin.find_files(telescope_themes.get_ivy(opts))
  else
    vim.notify("Zk notebook not found!", vim.log.levels.ERROR)
  end
end

M.create_note = function()
  telescope_pickers.create("dropdown", templates, {
    prompt_title = "Notes (create from template)",
    callback = function(selection)
      local opts = {}
      opts.dir = selection.value.directory
      if selection.value.ask_for_title then
        opts.title = vim.fn.input "Title: "
        if opts.title == "" or opts.title == nil then return end
      else
        opts.title = selection.value.label
      end
      zk.new(opts)
    end,
  })
end

M.create_note_with_title = function()
  local lines = util.buffer.get_visual_selection()
  local chunk = table.concat(lines)
  local location = vim.lsp.util.make_given_range_params()
  location.uri = location.textDocument.uri
  location.textDocument = nil
  location.range = chunk
  if chunk == nil then error "No selected text" end
  telescope_pickers.create("dropdown", templates, {
    prompt_title = "Notes (create from template)",
    callback = function(selection)
      local opts = {}
      opts.dir = selection.value.directory
      zk.new(vim.tbl_extend("force", { insertLinkAtLocation = location, title = chunk }, opts or {}))
    end,
  })
end

M.create_note_with_content = function()
  local lines = util.buffer.get_visual_selection()
  local chunk = table.concat(lines)
  local location = vim.lsp.util.make_given_range_params()
  location.uri = location.textDocument.uri
  location.textDocument = nil
  location.range = chunk
  if chunk == nil then error "No selected text" end
  telescope_pickers.create("dropdown", templates, {
    callback = function(selection)
      local opts = {}
      opts.prompt_title = "Notes (create from template)"
      opts.dir = selection.value.directory
      if selection.value.ask_for_title then
        opts.title = vim.fn.input "Title: "
        if opts.title == "" or opts.title == nil then return end
      else
        opts.title = selection.value.label
      end
      zk.new(vim.tbl_extend("force", { insertLinkAtLocation = location, content = chunk }, opts or {}))
    end,
  })
end

M.find_orphans = function() M.edit_with({ orphan = true }, { title = "Notes (orphaned)" }) end

M.find_recent_notes = function() M.edit_with({ createdAfter = "2 weeks ago" }, { title = "Notes (recent)" }) end

M.find_templated_note = function(template)
  M.edit_with({ hrefs = { template }, sort = { "created" } }, { title = string.format("Notes (%s)", template) })
end

M.find_tagged_notes = function()
  zk.pick_tags({}, { telescope = telescope_themes.get_dropdown {}, title = "Notes (tags)" }, function(tags)
    tags = vim.tbl_map(function(v) return v.name end, tags)
    M.edit_with({ tags = tags }, { title = ("Notes (tagged as %s)"):format(vim.inspect(tags)) })()
  end)
end

M.grep_notes = function(opts)
  opts = vim.F.if_nil(opts, {})
  local options = opts.fargs and unpack(opts.fargs) or {}
  local notebook_path = options.notebook_path or zku.resolve_notebook_path(0)
  local notebook_root = zku.notebook_root(notebook_path)
  assert(notebook_root ~= nil and #notebook_root > 0, "No notebook found.")
  telescope_builtin.live_grep { cwd = notebook_root, prompt_title = "Notes (live grep)" }
end

M.create_note_from_selection = function(opts)
  opts = vim.F.if_nil(opts, {})
  local cmd = unpack(opts.fargs)
  if cmd == "content" then
    M.create_note_with_title()
  elseif cmd == "title" then
    M.create_note_with_content()
  else
    error(("Invalid option to create note: '%s'"):format(cmd))
  end
end

M.insert_link = function(opts)
  opts = vim.F.if_nil(opts, {})
  local options = opts.fargs and unpack(opts.fargs) or {}
  zk.pick_notes(
    options,
    { telescope = telescope_themes.get_ivy {}, title = "Notes (insert link to note)", multi_select = false },
    function(notes)
      local pos = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local pwd = vim.fn.expand "%:p:h:t"
      notes = { notes }
      for _, note in ipairs(notes) do
        local npath = note.path
        if pwd ~= npath then npath = ("../%s"):format(npath) end
        local updated = ("%s[%s](%s)%s"):format(line:sub(0, pos), note.title, npath:sub(1, -6), line:sub(pos + 1))
        vim.api.nvim_set_current_line(updated)
      end
    end
  )
end

M.insert_link_from_selection = function(opts)
  opts = vim.F.if_nil(opts, {})
  local options = opts.fargs and unpack(opts.fargs) or {}
  local lines = util.buffer.get_visual_selection()
  local selection = table.concat(lines)
  zk.pick_notes(
    options,
    {
      telescope = telescope_themes.get_ivy {},
      title = ("Notes (link '%s' to note)"):format(selection),
      multi_select = false,
    },
    function(notes)
      local pos = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local pwd = vim.fn.expand "%:p:h:t"
      notes = { notes }
      for _, note in ipairs(notes) do
        local npath = note.path
        if pwd ~= npath then npath = ("../%s"):format(npath) end
        local updated = ("%s[%s](%s)%s"):format(
          line:sub(0, pos - #selection),
          selection,
          npath:sub(1, -6),
          line:sub(pos + 1)
        )
        vim.api.nvim_set_current_line(updated)
      end
    end
  )
end

return M
