-- print inspection of variable
---@return string
function P(...)
  print(vim.inspect(...))
end

if pcall(require, "plenary") then
  -- live-reload lua functions
  ---@param name string
  ---@return none
  function R(name)
    require("plenary.reload").reload_module(name)
    return require(name)
  end
end
