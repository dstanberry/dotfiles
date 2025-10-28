---@class remote.lsp.config
local M = { disabled = true }

M.config = {
  init_options = {
    activateSnykCode = "true",
    activateSnykIac = "false",
    activateSnykOpenSource = "false",
    additionalParams = "", -- "--all-projects"
    enableTrustedFoldersFeature = "false",
    insecure = "true",
    organization = ds.env "snyk.org",
    token = ds.env "snyk.token",
    trustedFolders = { vim.env.XDG_CONFIG_HOME, vim.g.projects_dir },
    sendErrorReports = "false",
    enableTelemetry = "false",
  },
}

return function() return M end
