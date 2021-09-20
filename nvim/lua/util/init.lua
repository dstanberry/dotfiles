local M = {}

M.callbacks = {}

function M.delegate(cb, expr)
  local key = tostring(cb)
  M.callbacks[key] = cb
  if expr then
    return ([[luaeval('require("util").execute("%s")')]]):format(key)
  end
  return ([[lua require("util").execute("%s")]]):format(key)
end

function M.execute(id)
  local func = M.callbacks[id]
  if not func then
    error("Function doest not exist: " .. id)
  end
  return func()
end

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

function M.define_autocmd(spec)
  local event = spec.event
  if type(event) == "table" then
    event = table.concat(event, ",")
  end
  local pattern = spec.pattern or "*"
  local once = spec.once and "++once" or ""
  local nested = spec.nested and "++nested" or ""
  local action = spec.command or ""
  if spec.callback ~= nil and type(spec.callback) == "function" then
    action = M.delegate(spec.callback)
  end
  local command = table.concat(vim.tbl_flatten { "autocmd", event, pattern, once, nested, action }, " ")
  vim.api.nvim_command(command)
end

function M.define_augroup(group)
  local clear_suffix = group.buf and " * <buffer>" or ""
  vim.api.nvim_command("augroup " .. group.name)
  if group.clear then
    vim.api.nvim_command("autocmd!" .. clear_suffix)
  end
  for _, autocmd in ipairs(group.autocmds) do
    M.define_autocmd(autocmd)
    vim.api.nvim_command "augroup END"
  end
end

return M
