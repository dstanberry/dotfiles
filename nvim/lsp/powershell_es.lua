---@class remote.lsp.config
local M = { defer_setup = not ds.has "win32" }

-- stylua: ignore
local command_fmt = {
  "%s/PowerShellEditorServices/Start-EditorServices.ps1",
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
local basedir = ds.plugin.get_pkg_path "powershell-editor-services"
local cache = vim.fn.stdpath "cache"
local command = table.concat(command_fmt, " "):format(basedir, basedir, cache, cache)

M.config = {
  bundle_path = basedir,
  cmd = function(dispatchers)
    return vim.lsp.rpc.start({ "pwsh.exe", "-NoLogo", "-NoProfile", "-Command", command }, dispatchers)
  end,
  init_options = { enableProfileLoading = false, locale = "en-us" },
  settings = {
    powershell = {
      codeFormatting = { preset = "OTBS" },
    },
  },
  on_attach = function()
    local handlers = require "remote.lsp.handlers"
    ds.format.register(
      handlers.formatter { name = "pwsh: lsp", primary = false, priority = 200, filter = "powershell_es" }
    )
  end,
}

return function() return M end
