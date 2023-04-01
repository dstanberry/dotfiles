local M = {}

---Utility to load linux directory hashes (if defined) into the current runtime
---@param shell any
function M.load_dirhash(shell)
  if has "win32" then return end
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
  local loader = function(rc_dir)
    local path = vim.fs.normalize(("%s/%s/%s/hashes.%s"):format(vim.env.XDG_CONFIG_HOME, shell, rc_dir, shell))
    local cmd = ([[%s -c "source %s; hash -d"]]):format(shell, path)
    local dirs = vim.fn.system(cmd)
    local lines = vim.split(dirs, "\n")
    for _, line in pairs(lines) do
      local pair = vim.split(line, "=")
      if #pair == 2 then
        local var = pair[1]
        local dir = pair[2]
        if vim.env["hash_" .. var] == nil then vim.env["hash_" .. var] = dir end
      end
    end
  end
  loader "rc"
  loader "rc.private"
end

---Utility function to load machine-specific overrides that can disable various configuration options/settings
function M.load_settings()
  local file = M.read(vim.fn.stdpath "config" .. "/settings.json", "r")
  if file then
    local options = vim.json.decode(file)
    for k, v in pairs(options) do
      vim.g["config_" .. k] = v
    end
  end
end

---@alias openmode
---|>"r"   # Read mode.
---| "w"   # Write mode.
---| "a"   # Append mode.
---| "r+"  # Update mode, all previous data is preserved.
---| "w+"  # Update mode, all previous data is erased.
---| "a+"  # Append update mode, previous data is preserved, writing is only allowed at the end of file.
---| "rb"  # Read mode. (in binary mode.)
---| "wb"  # Write mode. (in binary mode.)
---| "ab"  # Append mode. (in binary mode.)
---| "r+b" # Update mode, all previous data is preserved. (in binary mode.)
---| "w+b" # Update mode, all previous data is erased. (in binary mode.)
---| "a+b" # Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)

---Utility function to read a file on disk
---@param filePath string
---@param mode? openmode
---@return file*?
---@return string? errmsg
function M.read(filePath, mode)
  mode = vim.F.if_nil(mode, "r")
  local file = io.open(filePath, "r")
  if file then
    local data = file:read "*a"
    file.close()
    return data
  end
end

return M
