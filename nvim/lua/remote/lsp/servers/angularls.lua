local util = require "util"

local path = vim.fs.normalize(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local install_dir =
  vim.fs.normalize(string.format("%s/angular-language-server/node_modules/@angular/language-server", path))

local node_modules = function(dirs)
  return util.map(dirs, function(dir) return table.concat({ dir, "node_modules" }, "/") end)
end

local function get_cmd(workspace_dir)
  local cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    table.concat(node_modules { install_dir, workspace_dir }, ","),
    "--ngProbeLocations",
    table.concat(
      node_modules {
        table.concat({ install_dir, "node_modules", "@angular", "language-service" }, "/"),
        workspace_dir,
      },
      ","
    ),
  }
  if has "win32" then
    local exec = vim.fn.exepath(cmd[1])
    cmd[1] = exec ~= "" and exec or "ngserver"
  end
  return cmd
end

local M = {}

M.config = {
  cmd = get_cmd(vim.loop.cwd()),
  on_new_config = function(new_config, root_dir) new_config.cmd = get_cmd(root_dir) end,
  on_attach = function() end,
}

return M
