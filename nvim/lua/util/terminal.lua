local M = {}

local launch_term = function(task, opts)
  vim.cmd.new { range = { 5 }, mods = { split = "belowright" } }
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  vim.fn.termopen(task, opts)
  vim.cmd.startinsert()
end

-- HACK: concatenate multiple commands
local transform_win_cmd = function(install_cmd)
  local win_cmd = ""
  for cmd in install_cmd:gmatch "([^\n]*)\n?" do
    cmd = cmd:gsub("^%s*", "")
    if #cmd > 0 then
      if #win_cmd == 0 then
        win_cmd = cmd
      else
        win_cmd = ("%s && %s"):format(win_cmd, cmd)
      end
    end
  end
  return win_cmd
end

---Spawns a terminal instance in a new split and executes the provided script.
---The instance is removed when the script ends.
---@param name string
---@param basedir string
---@param path string
---@param script string
---@param force boolean
function M.install_package(name, basedir, path, script, force)
  if force then vim.fn.delete(basedir, "rf") end
  if not vim.loop.fs_stat(basedir) then
    print("Installing " .. name)
    vim.fn.mkdir(basedir, "p")
    if has "win32" then script = transform_win_cmd(script) end
    launch_term(script, {
      cwd = path,
      ["on_exit"] = function(_, code)
        if code ~= 0 then error("Failed to install " .. name) end
        local winid = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(winid, true)
        print("Installed " .. name)
      end,
    })
  end
end

return M
