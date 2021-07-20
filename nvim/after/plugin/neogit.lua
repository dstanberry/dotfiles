---------------------------------------------------------------
-- => neogit configuration
---------------------------------------------------------------
-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

-- default options
neogit.setup {
  signs = {
    hunk = { "", "" },
    item = { "", "" },
    section = { "", "" },
  },
}
