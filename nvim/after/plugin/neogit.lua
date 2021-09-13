---------------------------------------------------------------
-- => neogit configuration
---------------------------------------------------------------
-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

neogit.setup {
  signs = {
    hunk = { "", "" },
    item = { "", "" },
    section = { "", "" },
  },
}

local nnoremap = require("util.map").nnoremap

nnoremap("<leader>gs", function()
  neogit.open { kind = "split" }
end)
