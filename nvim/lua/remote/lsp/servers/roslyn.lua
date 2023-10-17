-- verify rust-tools is available
local ok, roslyn = pcall(require, "roslyn")
if not ok then return end

local M = {}

M.defer_setup = true

M.setup = function(config)
  roslyn.setup {
    dotnet_cmd = "dotnet",
    capabilities = config and config.capabilities and config.capabilities,
    on_attach = config and config.on_attach and config.on_attach,
  }
end

return M
