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
  settings = {
    powershell = {
      codeFormatting = {
        addWhitespaceAroundPipe = true,
        autoCorrectAliases = false,
        ignoreOneLineBlock = true,
        newLineAfterCloseBrace = true,
        newLineAfterOpenBrace = true,
        openBraceOnSameLine = true,
        pipelineIndentationStyle = "NoIndentation",
        preset = "Custom",
        trimWhitespaceAroundPipe = false,
        useConstantStrings = false,
        useCorrectCasing = false,
        whitespaceAfterSeparator = true,
        whitespaceAroundOperator = true,
        whitespaceAroundPipe = true,
        whitespaceBeforeOpenBrace = true,
        whitespaceBeforeOpenParen = true,
        whitespaceBetweenParameters = false,
        whitespaceInsideBrace = true,
      },
    },
  },
}

return M
