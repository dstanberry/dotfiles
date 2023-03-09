local util = require "util"

local path = vim.fn.expand(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local install_dir =
  vim.fn.expand(string.format("%s/angular-language-server/node_modules/@angular/language-server", path))
local sep = has "win32" and "\\" or "/"

local node_modules = function(dirs)
  return util.map(function(agg, dir, i)
    agg[i] = table.concat({ dir, "node_modules" }, sep)
    return agg
  end, dirs)
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
        table.concat({ install_dir, "node_modules", "@angular", "language-service" }, sep),
        workspace_dir,
      },
      ","
    ),
  }
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

local M = {}

M.config = {
  cmd = get_cmd(vim.loop.cwd()),
  on_new_config = function(new_config, root_dir) new_config.cmd = get_cmd(root_dir) end,
}

return M
