---------------------------------------------------------------
-- => Load plugin configurations
---------------------------------------------------------------
local plugins = {}

plugins.source = function()
  for _, mod in ipairs(vim.api.nvim_get_runtime_file("lua/remote/**/*.lua", true)) do
    local ok, msg = pcall(loadfile(mod))
    if not ok then
      print("Failed to load: ", mod)
      print("\t", msg)
    end
  end
end

return plugins
