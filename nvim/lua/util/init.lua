local M = {}

---Prints lua formatted representation of the given file as a module
---@param filename string
---@return string modname
function M.get_module_name(filename)
  local modname
  if has "win32" then
    modname = (filename):match "lua\\(.+)%.lua$"
    if modname ~= nil then
      modname = (modname):gsub("\\", ".")
    end
  else
    modname = (filename):match "lua/(.+)%.lua$"
    if modname ~= nil then
      modname = (modname):gsub("/", ".")
    end
  end
  modname = (modname):gsub(".init", "")
  return modname or ""
end

---Utility to load linux directory hashes (if defined) into the current runtime
---@param shell any
function M.load_dirhash(shell)
  if has "win32" then
    return
  end
  if shell == nil then
    print "cannot load hashes without specifying shell"
    return
  end
  if shell:find "bash" then
    shell = "bash"
  elseif shell:find "zsh" then
    shell = "zsh"
  end
  if not vim.tbl_contains({ "bash", "zsh" }, shell) then
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

---Utility function to load machine-specific overrides that can disable various configuration options/settings
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

---Creates a new table populated with the results of calling a provided function
--on every key-value pair in the calling table.
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param newList T?
---@return T #A new table with each key-value pair being the result of the callback function
function M.map(callback, list, newList)
  newList = newList or {}
  for k, v in pairs(list) do
    newList = callback(newList, v, k)
    if newList == nil then
      error "|newList| must be returned on each iteration and cannot be null"
    end
  end
  return newList
end

---Unloads the provided module from memory and re-requires it
---@param modname string
function M.reload(modname)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(modname)
  end
  return require(modname)
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
