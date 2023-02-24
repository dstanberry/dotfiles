local path = vim.fn.expand(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local project_library_path =
  vim.fn.expand(string.format("%s/angular-language-server/node_modules/@angular/language-server/node_modules", path))
local cmd = {
  has "win32" and "cmd.exe /C ngserver" or "ngserver",
  "--stdio",
  "--tsProbeLocations",
  project_library_path,
  "--ngProbeLocations",
  project_library_path,
}

local M = {}

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, _)
    new_config.cmd = cmd
  end,
}

return M
