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
  mode = mode or "r"
  resume = resume or false
  local fd = io.open(file, mode)
  if not (fd or resume) then vim.notify(("Could not open file (%s)"):format(file), vim.log.levels.ERROR) end
  if fd then
    local data = fd:read "*a"
    fd.close()
    return data
  end
end

---Recursive filesystem walker that traverses `path` and
---applies a provided function `fn` to each file or directory it encounters
---@param path string
---@param fn fun(path: string, name:string, type:util.fs.walker.filetype)
function M.walk(path, fn)
  M.walker(path, function(child, name, type)
    if type == "directory" then M.walk(child, fn) end
    fn(child, name, type)
  end)
end

---@alias util.fs.walker.filetype "file"|"directory"|"link"
---Filesystem walker that iterates over each file or directory in a given `path`,
---applying the function `fn` to each, and stops if `fn` returns `false`.
---@param path string
---@param fn fun(path: string, name:string, type:util.fs.walker.filetype):boolean?
function M.walker(path, fn)
  if not vim.uv.fs_stat(path) then
    local rtpaths = vim.api.nvim_list_runtime_paths()
    for _, rtp in ipairs(rtpaths) do
      local check = rtp .. "/" .. path
      if vim.uv.fs_stat(check) then
        path = check
        break
      elseif vim.uv.fs_stat(rtp .. "/lua/" .. path) then
        path = rtp .. "/lua/" .. path
      end
    end
  end
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local fname = path .. "/" .. name
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then break end
  end
end

---Utility function to write to a file on disk
---@param file string
---@param data string|number
function M.write(file, data, mode)
  mode = mode or "w"
  vim.fn.mkdir(vim.fs.dirname(file), "p")
  local fd = assert(io.open(file, mode))
  fd:write(data)
  fd:close()
end

return M
