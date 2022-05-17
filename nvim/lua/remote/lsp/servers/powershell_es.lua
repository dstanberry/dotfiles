local util = require "util"

local basedir = vim.fn.expand(string.format("%s/lspconfig", vim.fn.stdpath "data"))
local root_path = vim.fn.expand(string.format("%s/PowerShellEditorServices", basedir))
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
local command = command_fmt:format(root_path, root_path, vim.fn.stdpath "cache", vim.fn.stdpath "cache")

local M = {}

M.setup = function(force)
  local install_cmd = [[
    git clone https://github.com/PowerShell/PowerShellEditorServices
    cd PowerShellEditorServices
    Install-Module InvokeBuild -Scope CurrentUser -Force
    Install-Module platyPS -Scope CurrentUser -Force
    Invoke-Build Build
  ]]
  util.terminal.install_package("PSES", root_path, basedir, install_cmd, force)
end

M.config = has "win32"
    and {
      bundle_path = root_path,
      cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", command },
      root_dir = require("lspconfig.util").find_git_ancestor or vim.loop.cwd(),
    }
  or {}

return M
