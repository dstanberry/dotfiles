-- verify neogit is available
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

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

local nnoremap = require("util.map").nnoremap

nnoremap("<leader>gs", function()
  neogit.open { kind = "split" }
end)

nnoremap("<leader>gc", function()
  neogit.open { "commit" }
end)
