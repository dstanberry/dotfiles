-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

local map = require("util.map")

neogit.setup {
  disable_commit_confirmation = true,
  disable_context_highlighting = false,
  disable_insert_on_commit = false,
  commit_popup = {
    kind = "split",
  },
  signs = {
    hunk = { "", "" },
    item = { "", "" },
    section = { "", "" },
  },
  integrations = {
    diffview = true,
  },
}

map.nnoremap("<leader>gs", function()
  neogit.open { kind = "split" }
end)

map.nnoremap("<leader>gc", function()
  neogit.open { "commit" }
end)
