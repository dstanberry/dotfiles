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
  local file = M.read(vim.fs.joinpath(vim.fn.stdpath "config", "dotenv.json"), "r")
  local options = file and vim.json.decode(file) or {}

  vim.g.ds_env = options
end

---Utility function to read a file on disk
---@param file string
---@param mode? openmode
---@param resume boolean
---@return file*?
---@return string? errmsg
function M.read(file, mode, resume)
  mode = vim.F.if_nil(mode, "r")
  resume = resume or false
  local fd = io.open(file, mode)
  if not (fd or resume) then vim.notify(("Could not open file (%s)"):format(file), vim.log.levels.ERROR) end
  if fd then
    local data = fd:read "*a"
    fd.close()
    return data
  end
end

---Utility function to write to a file on disk
---@param file string
---@param data string|number
function M.write(file, data, mode)
  mode = vim.F.if_nil(mode, "w")
  vim.fn.mkdir(vim.fs.dirname(file), "p")
  local fd = assert(io.open(file, mode))
  fd:write(data)
  fd:close()
end

return M
