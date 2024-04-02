local M = {}

M.config = {
  init_options = {
    activateSnykOpenSource = "true",
    activateSnykCode = "true",
    activateSnykIac = "false",
    insecure = "true",
    -- additionalParams = "--all-projects",
    additionalParams = "",
    organization = vim.g.config_snyk_org,
    token = vim.g.config_snyk_token,
    enableTrustedFoldersFeature = "true",
    trustedFolders = { vim.env.XDG_CONFIG_HOME, vim.g.projects_dir },
    sendErrorReports = "false",
    enableTelemetry = "false",
  },
}

return M
