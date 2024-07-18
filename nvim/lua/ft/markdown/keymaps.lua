local markdown = require "ft.markdown"

local edit = function() markdown.zk.edit({}, { title = "Notes" }) end

local edit_links = function()
  markdown.zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (links)" })
end

local edit_backlinks = function()
  markdown.zk.edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (backlinks)" })
end

local edit_tags = function()
  markdown.zk.pick_tags({}, { title = "Notes (tags)" }, function(tags)
    tags = vim.tbl_map(function(v) return v.name end, tags)
    markdown.zk.edit({ tags = tags }, { title = ("Notes (tagged with: %s)"):format(vim.inspect(tags)) })
  end)
end

local new_from_selection = function(where) markdown.zk.new_from_selection { location = where } end
local title_from_selection = function() new_from_selection "title" end
local content_from_selection = function() new_from_selection "content" end

-- standard
vim.keymap.set("n", "<leader>ml", edit_links, { desc = "zk: find notes (links)" })
vim.keymap.set("n", "<leader>mg", markdown.zk.live_grep, { desc = "zk: find in notes (grep)" })
vim.keymap.set("n", "<leader>mm", markdown.zk.new, { desc = "zk: create note" })
vim.keymap.set("n", "<leader>mt", edit_tags, { desc = "zk: find notes (tags)" })
vim.keymap.set("x", "<leader>mr", title_from_selection, { desc = "zk: create note (using selection as title)" })

-- somewhat analagous to `<leader>` maps
vim.keymap.set("n", "<localleader>ml", edit_backlinks, { desc = "zk: find notes (backlinks)" })
vim.keymap.set("n", "<localleader>mm", edit, { desc = "zk: edit note(s)" })
-- stylua: ignore
vim.keymap.set( "x", "<localleader>mr", content_from_selection, { desc = "zk: create note (using selection as content)" })
