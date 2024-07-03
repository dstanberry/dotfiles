local M = {}

local basedir = vim.fs.normalize(string.format("%s/mason/packages/powershell-editor-services", vim.fn.stdpath "data"))
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
local command = table.concat(command_fmt, " "):format(basedir, basedir, vim.fn.stdpath "cache", vim.fn.stdpath "cache")

M.config = {
  bundle_path = basedir,
  cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", command },
  root_dir = require("lspconfig.util").find_git_ancestor or vim.uv.cwd(),
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

M.defer_setup = not ds.has "win32"

return M
