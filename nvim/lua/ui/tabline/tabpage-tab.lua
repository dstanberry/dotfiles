local options = require "ui.tabline.options"
local highlights = require "ui.tabline.highlights"

local Tabpage = {}
Tabpage.__index = Tabpage

function Tabpage:generate_hl()
  local hlgroups = options.get().hlgroups
  local name = self.current and "current" or "normal"
  self.hl = hlgroups["tabpage_" .. name] or hlgroups[name] or hlgroups.normal or ""
end

function Tabpage:new(opts)
  local index, current = opts.index, opts.current

  local t = {}
  t.index = index
  t.insert_at = index
  t.current = current
  t.format = options.get().tabpage_format
  t.position = options.get().tabpage_position

  setmetatable(t, self)

  t:generate_hl()
  return t
end

function Tabpage:get_width()
  return vim.fn.strchars(self.label)
end

function Tabpage:highlight()
  self.label = highlights.add_hl(self.label, self.hl)
end

function Tabpage:generate(budget)
  self.label = self.format
  self.label = self.label:gsub("#{n}", self.index)
  local adjusted = budget - self:get_width()

  self:highlight()
  return adjusted, self.label
end

return Tabpage
