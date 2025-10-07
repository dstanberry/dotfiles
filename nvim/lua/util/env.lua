---@class util.env
---@overload fun(name?: string)
local M = setmetatable({}, {
  __call = function(m, ...) return m.get(...) end,
})

---Retrieves the value of an environment variable by its name.
---@param name string|string[] The name of the environment variable to retrieve.
---Can be a dot-separated string or a list of strings for nested access.
function M.get(name)
  name = type(name) == "table" and name or vim.split(name, ".", { plain = true })
  return name and vim.tbl_get(vim.g, "ds_env", unpack(name)) or ""
end

---Utility function to load machine-specific overrides that can disable various configuration options/settings
function M.load_settings()
  local file = ds.fs.read(vim.fs.joinpath(vim.fn.stdpath "config", "dotenv.json"), "r")
  vim.g.ds_env = file and vim.json.decode(file) or {}
end

return M
