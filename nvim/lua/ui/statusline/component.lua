local highlight = require "ui.statusline.highlight"

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

function Component:highlight(name)
  if name == "modehl" then
    self.hl = highlight.mode(vim.fn.mode())
  else
    self.hl = highlight[name]
  end
  if self.hl then self.label = string.format("%s%s", self.hl, self.label) end
end

function Component:load()
  for hl, component in pairs(self.section) do
    local opts = vim.deepcopy(self)
    if type(component) == "table" then
      local copy = vim.deepcopy(component)
      local tmp = table.remove(copy, 1)
      opts = vim.tbl_deep_extend("force", opts, copy)
      component = tmp
    end
    local ok, mod = pcall(require, ("ui.statusline.components.%s"):format(component))
    if ok then
      self.label = mod
      if type(mod) == "function" or type(mod) == "table" then self.label = mod(opts) end
    elseif type(component) == "function" then
      self.label = component(opts)
    else
      self.label = tostring(component)
    end
    self:highlight(hl)
  end
end

return Component
