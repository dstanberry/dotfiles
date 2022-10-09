local Object = {}

Object.__index = Object

function Object:init(...) end

function Object:new(properties)
  local c = {}
  c.options = properties

  setmetatable(c, self)
  c:init(properties)
  c:load()
  c:apply_padding()
  return c.label
end

function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find "__" == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

function Object:apply_padding()
  local padding = self.options.padding
  local l_padding, r_padding
  if padding == nil then
    padding = 1
  end
  if type(padding) == "number" then
    l_padding, r_padding = padding, padding
  elseif type(padding) == "table" then
    l_padding, r_padding = padding.left, padding.right
  end
  if l_padding then
    self.label = ("%s%s"):format(string.rep(" ", l_padding), self.label)
  end
  if r_padding then
    self.label = ("%s%s"):format(self.label, string.rep(" ", r_padding))
  end
end

function Object:__call(...)
  return self:new(...)
end

return Object
