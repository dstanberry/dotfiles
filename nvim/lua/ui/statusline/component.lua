local highlighter = require "ui.statusline.highlighter"

local Component = {}
Component.__index = Component

function Component:new(properties, section)
  local c = {}
  c.winid = properties.winid
  c.buf = properties.bufnr
  c.filetype = properties.filetype
  c.name = properties.name
  c.section = section

  setmetatable(c, self)
  c:load()
  return c.label
end

function Component:highlight(attr)
  if type(attr) == "string" and attr == "mode" then
    self.hl = highlighter.mode(vim.fn.mode())
  elseif type(attr) == "table" then
    local hlgroup = self.section.component
    if self.name == "separator" then
      hlgroup = self.name
    elseif #hlgroup == 0 or hlgroup:match "%S" == nil then
      hlgroup = "empty_cell"
    end
    self.hl = highlighter.create_hl("statusline_" .. hlgroup, attr)
  end
  if self.hl then self.label = string.format("%s%s", self.hl, self.label) end
end

function Component:load()
  local copy = vim.deepcopy(self)
  local opts = vim.F.if_nil(self.section.opts, {})
  opts = vim.tbl_deep_extend("force", opts, copy)
  local ok, mod = pcall(require, ("ui.statusline.components.%s"):format(self.section.component))
  if ok then
    self.label = mod
    if type(mod) == "function" or type(mod) == "table" then self.label = mod(opts) end
  elseif type(self.section.component) == "function" then
    self.label = self.section.component(opts)
  else
    self.label = tostring(self.section.component)
  end
  if self.section.highlight then self:highlight(self.section.highlight) end
end

return Component
