local M = {}

M.spawn_term = function(task, opts)
  vim.cmd [[5new]]
  if vim.fn.has "win32" == 1 then
    vim.fn.termopen(task, opts)
  else
    vim.fn.termopen("set -e\n" .. task, opts)
  end
  vim.cmd [[startinsert]]
end

M.transform_win_cmd = function(install_cmd)
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

M.install_package = function(name, basedir, path, script, force)
  if force then
    vim.fn.delete(basedir, "rf")
  end
  if vim.fn.empty(vim.fn.glob(basedir)) > 0 then
    print("Installing " .. name)
    vim.fn.mkdir(basedir, "p")
    if vim.fn.has "win32" then
      script = M.transform_win_cmd(script)
    end
    M.spawn_term(script, {
      cwd = path,
      ["on_exit"] = function(_, code)
        if code ~= 0 then
          error("Failed to install " .. name)
        end
        local win = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_delete(bufnr, { force = true })
        print("Installed " .. name)
      end,
    })
  end
end

return M
