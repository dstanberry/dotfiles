local util = require "util"

local path = vim.fn.expand(string.format("%s/mason/packages", vim.fn.stdpath "data"))
local basedir = vim.fn.expand(string.format("%s/PowerShellEditorServices", path))
-- stylua: ignore
local command_fmt = {
  "%s/module/PowerShellEditorServices/Start-EditorServices.ps1",
  "-BundledModulesPath", "%s",
  "-LogPath", "%s/powershell_es.log",
  "-SessionDetailsPath", "%s/powershell_es.session.json",
  "-HostName","nvim",
  "-HostProfileId","0",
  "-HostVersion","1.0.0",
  -- "-FeatureFlags", "@()",
  -- "-AdditionalModules", "@()",
  "-Stdio",
  "-LogLevel","Normal",
}
command_fmt = table.concat(command_fmt, " ")
local command = command_fmt:format(basedir, basedir, vim.fn.stdpath "cache", vim.fn.stdpath "cache")

local M = {}

M.setup = function(force)
  local install_cmd = [[
    cd PowerShellEditorServices
    Install-Module InvokeBuild -Scope CurrentUser -Force
    Install-Module platyPS -Scope CurrentUser -Force
    Invoke-Build Build
  ]]
  util.terminal.install_package("PSES", basedir, path, install_cmd, force)
end

M.config = has "win32"
    and {
      bundle_path = basedir,
      cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", command },
      root_dir = require("lspconfig.util").find_git_ancestor or vim.loop.cwd(),
    }
  or {}

return M
