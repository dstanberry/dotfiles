local markdown = require "ft.markdown"

local create_note_from_selection = function()
  vim.cmd { cmd = "ZkReference", args = { "title" }, mods = { keepmarks = true } }
end

-- standard
vim.keymap.set("n", "<leader>mg", markdown.zk.grep_notes, { desc = "zk: find in notes (grep)" })
vim.keymap.set("n", "<leader>mm", markdown.zk.create_note, { desc = "zk: create note" })
vim.keymap.set("x", "<leader>mr", create_note_from_selection, { desc = "zk: create note (from selection)" })
vim.keymap.set("n", "<leader>mt", markdown.zk.find_tagged_notes, { desc = "zk: find notes (tags)" })

-- somewhat analagous to `<leader>` maps
vim.keymap.set("n", "<localleader>mm", markdown.zk.find_notes, { desc = "zk: find notes" })
vim.keymap.set("x", "<localleader>mr", create_note_from_selection, { desc = "zk: create note (from selection)" })
