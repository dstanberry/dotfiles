local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local action_utils = require "telescope.actions.utils"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local M = {}

local default_entry_maker = function(entry)
  return {
    ordinal = entry.label,
    display = entry.label,
    value = entry,
  }
end

M.create = function(theme, content, opts)
  local theme_opts

  if theme == "dropdown" then
    theme_opts = require("telescope.themes").get_dropdown {}
  elseif theme == "cursor" then
    theme_opts = require("telescope.themes").get_cursor {}
  elseif theme == "ivy" then
    theme_opts = require("telescope.themes").get_ivy {}
  end

  pickers
    .new(theme_opts, {
      prompt_title = opts.title or "",
      finder = finders.new_table {
        results = content,
        entry_maker = opts.entry_maker or default_entry_maker,
      },
      previewer = opts.previewer or nil,
      sorter = conf.generic_sorter(theme_opts),
      attach_mappings = function(bufnr, _)
        actions.select_default:replace(function()
          local selection
          if opts.multi_select then
            selection = {}
            action_utils.map_selections(bufnr, function(entry, _) table.insert(selection, entry.value) end)
            if vim.tbl_isempty(selection) then selection = action_state.get_selected_entry() end
            actions.close(bufnr)
          else
            actions.close(bufnr)
            selection = action_state.get_selected_entry()
          end
          if opts.callback then opts.callback(selection) end
        end)
        return true
      end,
    })
    :find()
end

return M
