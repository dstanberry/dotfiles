local buffers = require "ui.tabline.buffers"
local tabpages = require "ui.tabline.tabpages"
local highlights = require "ui.tabline.highlights"
local options = require "ui.tabline.options"

local make_separator = function(budget)
  local spacing = {}
  for _ = 1, budget do
    table.insert(spacing, " ")
  end

  local to_string = table.concat(spacing)
  local hl = options.get().hlgroups.spacing
  return hl and highlights.add_hl(to_string, hl) or to_string
end

return function()
  local budget = vim.o.columns
  local tabs = {}
  vim.list_extend(tabs, tabpages.make_tabpage_tabs())
  vim.list_extend(tabs, buffers.make_buftabs())

  local labels, insert_separator_at = {}, 0
  for _, tab in ipairs(tabs) do
    local remaining, label, last = tab:generate(budget, tabs)
    budget = remaining

    if tab.position == "right" or tabs[1].position == "left" then
      table.insert(labels, label)
    else
      table.insert(labels, tab.insert_at, label)
    end

    if last then
      insert_separator_at = tab.insert_at
      break
    end
  end

  local separator = make_separator(budget)
  if tabs[1] and tabs[1].position == "right" then
    table.insert(labels, insert_separator_at + 1, separator)
  else
    table.insert(labels, separator)
  end

  return table.concat(labels)
end
