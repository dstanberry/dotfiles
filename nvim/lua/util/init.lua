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
  if type(pattern) == "table" then
    pattern = table.concat(pattern, ",")
  end
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
  vim.api.nvim_command("autocmd!" .. clear_suffix)
  for _, autocmd in ipairs(group.autocmds) do
    M.define_autocmd(autocmd)
    vim.api.nvim_command "augroup END"
  end
end

function M.load_dirhash(s)
  if s == nil then
    error "cannot load hashes without specifying shell"
    return
  end
  local shell
  if s:find "bash" then
    shell = "bash"
  elseif s:find "zsh" then
    shell = "zsh"
  else
    shell = s
  end
  if shell ~= "bash" and shell ~= "zsh" then
    error("cannot load hashes for unsupported shell: " .. shell)
    return
  end
  local path = vim.fn.expand(("%s/%s/rc.private/hashes.%s"):format(vim.env.XDG_CONFIG_HOME, shell, shell))
  local cmd = ([[%s -c "source %s; hash -d"]]):format(shell, path)
  local dirs = vim.fn.system(cmd)
  local lines = vim.split(dirs, "\n")
  for _, line in pairs(lines) do
    local pair = vim.split(line, "=")
    if #pair == 2 then
      local var = pair[1]
      local dir = pair[2]
      if vim.env[var] == nil then
        vim.env[var] = dir
      end
    end
  end
end

return M
