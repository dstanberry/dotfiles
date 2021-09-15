local M = {}

-- force reload local/remote module configuration
function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

return M
