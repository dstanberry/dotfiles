local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local M = {}

local default_entry_maker = function(entry)
  return {
    ordinal = entry.ordinal,
    display = entry.label,
    value = entry,
  }
end

M.create_dropdown = function(content, opts)
  local dropdown_opts = require("telescope.themes").get_dropdown {}
  pickers.new(dropdown_opts, {
    prompt_title = "",
    finder = finders.new_table {
      results = content,
      entry_maker = opts.entry_maker or default_entry_maker,
    },
    sorter = conf.generic_sorter(dropdown_opts),
    attach_mappings = function(bufnr, _)
      actions.select_default:replace(function()
        actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        if opts.callback then
          opts.callback(selection)
        end
      end)
      return true
    end,
  }):find()
end

return M
