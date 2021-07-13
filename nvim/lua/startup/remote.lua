---------------------------------------------------------------
-- => Load plugin configurations
---------------------------------------------------------------
-- initialize modules table
local M = {}

-- load configuration files for remote plugins
M.setup = function()
  for _, mod in ipairs(vim.api.nvim_get_runtime_file("lua/remote/**/*.lua", true)) do
    local ok, msg = pcall(loadfile(mod))
    if not ok then
      print("Failed to load: ", mod)
      print("\t", msg)
    end
  end
end

return M
