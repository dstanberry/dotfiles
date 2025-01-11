local M = {}

M.disabled = true

M.config = {
  init_options = {
    activateSnykCode = "true",
    activateSnykIac = "false",
    activateSnykOpenSource = "false",
    additionalParams = "", -- "--all-projects"
    enableTrustedFoldersFeature = "false",
    insecure = "true",
    organization = vim.g.ds_env.snyk and vim.g.ds_env.snyk.org or nil,
    token = vim.g.ds_env.snyk and vim.g.ds_env.snyk.token or nil,
    trustedFolders = { vim.env.XDG_CONFIG_HOME, vim.g.projects_dir },
    sendErrorReports = "false",
    enableTelemetry = "false",
  },
}

return M
