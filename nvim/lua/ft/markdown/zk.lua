local telescope = require "telescope"
local telescope_builtin = require "telescope.builtin"
local telescope_themes = require "telescope.themes"

local telescope_pickers = require "remote.telescope.custom.pickers"

local zk = require "zk"
local zka = require "zk.api"
local zku = require "zk.util"

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

---Override of zk API |edit(...)|
---* Opens a `telescope` notes picker, and edits the selected notes
---@param options? table additional options
---@param picker_options? table options for the picker
M.edit = function(options, picker_options)
  options = options or {}
  picker_options = vim.tbl_extend("keep", picker_options, {
    picker = "telescope",
    telescope = telescope_themes.get_ivy {},
  })
  zk.edit(options, picker_options)
end

---Override of zk API |pick_tags(...)|
---* Opens a `telescope` tags picker, and calls the callback with the selection
---@param options? table additional options
---@param picker_options? table options for the picker
---@param cb function
M.pick_tags = function(options, picker_options, cb)
  options = options or {}
  picker_options = vim.tbl_extend("keep", picker_options, {
    picker = "telescope",
    telescope = telescope_themes.get_dropdown {},
  })
  zk.pick_tags(options, picker_options, cb)
end

---Override of zk API |pick_notes(...)|
---* Opens a `telescope` notes picker, and calls the callback with the selection
---@param options? table additional options
---@param picker_options? table options for the picker
---@param cb function
M.pick_notes = function(options, picker_options, cb)
  options = options or {}
  picker_options = vim.tbl_extend("keep", picker_options, {
    picker = "telescope",
    telescope = telescope_themes.get_ivy {},
  })
  zk.pick_notes(options, picker_options, cb)
end

---Override of zk API |new(...)|
---* Opens a `telescope` templates picker and creates/edits a new note based on the template chosen
---@param options? table additional options
M.new = function(options)
  options = options or {}
  telescope_pickers.create("dropdown", templates, {
    prompt_title = "Notes (create from template)",
    callback = function(selection)
      options.dir = selection.value.directory
      if selection.value.ask_for_title and not options.title then
        options.title = vim.fn.input "Title: "
        if options.title == "" or options.title == nil then return end
      end
      options.title = vim.F.if_nil(options.title, selection.value.label)
      zk.new(options)
    end,
  })
end

local make_given_range_params = function(range)
  local params = ds.reduce({ "start", "end" }, function(v, k)
    local row, col = unpack(range[k])
    col = (vim.o.selection ~= "exclusive" and v == "end") and col + 1 or col
    params[v] = { line = row, character = col }
    return params
  end)
  local location = vim.lsp.util.make_given_range_params()
  location.uri = location.textDocument.uri
  location.textDocument = nil
  location.range = params
  return location
end

---Using the current |`text selection`|, opens a `telescope` templates picker
---and creates/edits a new note based on the template chosen using the
---|`text selection`| as either the title or body of the note
---@param options? table additional options
M.new_from_selection = function(options)
  options = options or {}
  if not options.location and (options.location ~= "title" or options.location ~= "content") then
    error(("Invalid option to create note: '%s'"):format(tostring(options.location)))
  end
  local lines, range = ds.buffer.get_visual_selection()
  local chunk = table.concat(lines)
  if chunk == nil then error "Unable to create note: No selected text" end
  if not range then error("Invalid text selection. Invalid value for 'range': " .. vim.inspect(range)) end
  local location = make_given_range_params(range)
  vim.schedule(function() M.new { insertLinkAtLocation = location, [options.location] = chunk } end)
end

---Opens a `telescope` picker and inserts a link to the note
---in the current document using the title of the selected note
---@param options? table additional options
M.insert_link = function(options)
  options = options or {}
  M.pick_notes(options, { title = "Notes (insert link to note)", multi_select = false }, function(note)
    zka.link(note.path, zku.get_lsp_location_from_caret(), nil, {}, function(err, res)
      if not res then error(err) end
    end)
  end)
end

---Opens a `telescope` picker and inserts a link to the note
---in the current document using the current text selection
---@param options? table additional options
M.insert_link_from_selection = function(options)
  options = options or {}
  local lines, range = ds.buffer.get_visual_selection()
  local selection = table.concat(lines)
  if selection == nil then error "Unable to create note: No selected text" end
  if not range then error("Invalid text selection. Invalid value for 'range': " .. vim.inspect(range)) end
  local location = make_given_range_params(range)
  M.pick_notes(
    options,
    { title = ("Notes (link '%s' to note)"):format(selection), multi_select = false },
    function(note)
      zka.link(note.path, location, nil, { title = selection }, function(err, res)
        if not res then error(err) end
      end)
    end
  )
end

---Opens a `telescope` picker and edits the selection containing the current |grep| pattern
---@param options? table additional options
M.live_grep = function(options)
  options = options or {}
  local notebook_path = options.notebook_path and options.notebook_path or zku.resolve_notebook_path(0)
  local notebook_root = zku.notebook_root(notebook_path)
  if notebook_root == nil or #notebook_root == 0 then error "No notebook found." end
  telescope_builtin.live_grep { cwd = notebook_root, prompt_title = "Notes (live grep)" }
end

return M
