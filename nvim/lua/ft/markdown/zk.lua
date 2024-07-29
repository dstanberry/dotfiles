---@class ft.markdown.zk
local M = {}

local telescope = require "telescope"
local tb = require "telescope.builtin"
local tt = require "telescope.themes"
local tu = require "remote.telescope.util"
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

---Override of zk API |edit(...)|
---* Opens a `telescope` notes picker, and edits the selected notes
---@param opts? table additional options
---@param picker_opts? table options for the picker
M.edit = function(opts, picker_opts)
  opts = opts or {}
  picker_opts = vim.tbl_extend("keep", picker_opts or {}, {
    picker = "telescope",
    telescope = tt.get_ivy {},
    title = "Notes",
  })
  zk.edit(opts, picker_opts)
end

---Override of zk API |pick_tags(...)|
---* Opens a `telescope` tags picker, and calls the callback with the selection
---@param opts? table additional options
---@param picker_opts? table options for the picker
---@param cb function
M.pick_tags = function(opts, picker_opts, cb)
  opts = opts or {}
  picker_opts = vim.tbl_extend("keep", picker_opts or {}, {
    picker = "telescope",
    telescope = tt.get_dropdown {},
  })
  zk.pick_tags(opts, picker_opts, cb)
end

---Override of zk API |pick_notes(...)|
---* Opens a `telescope` notes picker, and calls the callback with the selection
---@param opts? table additional options
---@param picker_opts? table options for the picker
---@param cb function
M.pick_notes = function(opts, picker_opts, cb)
  opts = opts or {}
  picker_opts = vim.tbl_extend("keep", picker_opts or {}, {
    picker = "telescope",
    telescope = tt.get_ivy {},
  })
  zk.pick_notes(opts, picker_opts, cb)
end

---Override of zk API |new(...)|
---* Opens a `telescope` templates picker and creates/edits a new note based on the template chosen
---@param opts? table additional options
M.new = function(opts)
  opts = opts or {}
  opts.title = opts.title or "Notes (create from template)"
  tu.picker.create("dropdown", templates, {
    callback = function(selection)
      opts.dir = selection.value.directory
      if selection.value.ask_for_title and not opts.title then
        opts.title = vim.fn.input "Title: "
        if opts.title == "" or opts.title == nil then return end
      end
      opts.title = vim.F.if_nil(opts.title, selection.value.label)
      zk.new(opts)
    end,
  })
end

---Using the current |`text selection`|, opens a `telescope` templates picker
---and creates/edits a new note based on the template chosen using the
---|`text selection`| as either the title or body of the note
---@param opts? table additional options
M.new_from_selection = function(opts)
  opts = opts or {}
  if not opts.location and (opts.location ~= "title" or opts.location ~= "content") then
    ds.error(("Invalid option to create note: '%s'"):format(tostring(opts.location)), { title = "Zk" })
  end
  local lines, range = ds.buffer.get_visual_selection()
  local chunk = table.concat(lines)
  if not (chunk and #chunk > 0 and range) then return end
  local location = ds.buffer.make_lsp_range_params(range)
  location.uri = location.textDocument.uri
  location.textDocument = nil
  vim.schedule(function() M.new { insertLinkAtLocation = location, [opts.location] = chunk } end)
end

---Opens a `telescope` picker and inserts a link to the note
---in the current document using the title of the selected note
---@param opts? table additional options
M.insert_link = function(opts)
  opts = opts or {}
  M.pick_notes(opts, { title = "Notes (insert link to note)", multi_select = false }, function(note)
    zka.link(note.path, zku.get_lsp_location_from_caret(), nil, {}, function(err, res)
      if not res then ds.error(err, { title = "Zk" }) end
    end)
  end)
end

---Opens a `telescope` picker and inserts a link to the note
---in the current document using the current text selection
---@param opts? table additional options
M.insert_link_from_selection = function(opts)
  opts = opts or {}
  local lines, range = ds.buffer.get_visual_selection()
  local selection = table.concat(lines)
  if not (selection and #selection > 0 and range) then return end
  local location = ds.buffer.make_lsp_range_params(range)
  location.uri = location.textDocument.uri
  location.textDocument = nil
  M.pick_notes(opts, { title = ("Notes (link '%s' to note)"):format(selection), multi_select = false }, function(note)
    zka.link(note.path, location, nil, { title = selection }, function(err, res)
      if not res then ds.error(err, { title = "Zk" }) end
    end)
  end)
end

---Opens a `telescope` picker and edits the selection containing the current |grep| pattern
---@param opts? table additional options
M.live_grep = function(opts)
  opts = opts or {}
  local notebook_path = opts.notebook_path and opts.notebook_path or zku.resolve_notebook_path(0)
  local notebook_root = zku.notebook_root(notebook_path)
  if notebook_root == nil or #notebook_root == 0 then ds.error("No notebook found.", { title = "Zk" }) end
  tb.live_grep { cwd = notebook_root, prompt_title = "Notes (live grep)" }
end

return M
