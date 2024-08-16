local M = {}

M.config = {
  init_options = {
    activateSnykOpenSource = "true",
    activateSnykCode = "true",
    activateSnykIac = "false",
    insecure = "true",
    -- additionalParams = "--all-projects",
    additionalParams = "",
    organization = vim.g.ds_env.snyk and vim.g.ds_env.snyk.org or nil,
    token = vim.g.ds_env.snyk and vim.g.ds_env.snyk.token or nil,
    enableTrustedFoldersFeature = "true",
    trustedFolders = { vim.env.XDG_CONFIG_HOME, vim.g.projects_dir },
    sendErrorReports = "false",
    enableTelemetry = "false",
  },
}

return M
