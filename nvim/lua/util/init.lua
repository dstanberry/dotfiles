local M = {}

M.callbacks = {}

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

local function call(cb)
  local key = tostring(cb)
  M.callbacks[key] = cb
  return ([[lua require("util").callbacks["%s"]()]]):format(key)
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
  if spec.callback ~= nil then
    action = call(spec.callback)
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
