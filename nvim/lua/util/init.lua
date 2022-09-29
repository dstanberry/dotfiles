_G.__UtilCallbackStore = _G.__UtilCallbackStore or {}

local M = {
  _callbackStore = _G.__UtilCallbackStore,
}

function M._create_callback(key, callback)
  M._callbackStore[key] = callback
end

function M._execute_callback(id)
  local func = M._callbackStore[id]
  if not (func and type(func) == "function") then
    error(("Function does not exist: %s"):format(id))
  end
  return func()
end

function M.add_callback(cb, expr)
  local key = tostring(cb)
  M._create_callback(key, cb)
  if expr then
    return ([[luaeval('require("util")._execute_callback("%s")')]]):format(key)
  end
  return ([[lua require("util")._execute_callback("%s")]]):format(key)
end

function M.get_module_name(file)
  local mod
  if has "win32" then
    mod = (file):match "lua\\(.+)%.lua$"
    if mod ~= nil then
      mod = (mod):gsub("\\", ".")
    end
  else
    mod = (file):match "lua/(.+)%.lua$"
    if mod ~= nil then
      mod = (mod):gsub("/", ".")
    end
  end
  mod = (mod):gsub(".init", "")
  return mod or ""
end

function M.load_dirhash(s)
  if has "win32" then
    return
  end
  if s == nil then
    print "cannot load hashes without specifying shell"
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
    print("cannot load hashes for unsupported shell: " .. shell)
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
      if vim.env["hash_" .. var] == nil then
        vim.env["hash_" .. var] = dir
      end
    end
  end
end

function M.load_settings()
  local file = vim.fn.stdpath "config" .. "/settings.conf"
  local f = io.open(file, "rb")
  if f then
    f:close()
    for line in io.lines(file) do
      local parts = vim.split(line, "=")
      local l = vim.trim(parts[1])
      local r = tonumber(parts[2])
      vim.g["config_" .. l] = r
    end
  end
end

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

return setmetatable({}, {
  __index = function(t, k)
    if M[k] then
      return M[k]
    else
      local ok, val = pcall(require, string.format("util.%s", k))
      if ok then
        rawset(t, k, val)
        return val
      end
    end
  end,
})
