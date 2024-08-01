---@class util.fs
local M = {}

---Utility to load linux directory hashes (if defined) into the current runtime
---@param shell string
function M.load_dirhash(shell)
  if ds.has "win32" then return end
  local term = shell:find "zsh" and "zsh"
  if not (term and vim.env.XDG_CONFIG_HOME) then return end
  local loader = function(rc_dir)
    local path = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, term, rc_dir, "hashes." .. term)
    local cmd = ([[%s -c "source %s; hash -d"]]):format(term, path)
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
  local file = M.read(vim.fs.joinpath(vim.fn.stdpath "config", "settings.json"), "r")
  if file then
    local options = vim.json.decode(file)
    for k, v in pairs(options) do
      vim.g["config_" .. k] = v
    end
  end
end

---Utility function to read a file on disk
---@param file string
---@param mode? openmode
---@return file*?
---@return string? errmsg
function M.read(file, mode)
  mode = vim.F.if_nil(mode, "r")
  local fd = io.open(file, "r")
  if not fd then vim.notify(("Could not open file (%s)"):format(file), vim.log.levels.ERROR) end
  if fd then
    local data = fd:read "*a"
    fd.close()
    return data
  end
end

---Utility function to write to a file on disk
---@param file string
---@param data string|number
function M.write(file, data)
  local fd = io.open(file, "w")
  if not fd then vim.notify(("Could not open file (%s)"):format(file), vim.log.levels.ERROR) end
  if fd then
    fd:write(data)
    fd:close()
  end
end

return M
