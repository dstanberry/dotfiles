---------------------------------------------------------------
-- => neogit configuration
---------------------------------------------------------------
-- verify neogit is available
local ok, git = pcall(require, "neogit")
if not ok then
  return
end

-- default options
git.setup()
