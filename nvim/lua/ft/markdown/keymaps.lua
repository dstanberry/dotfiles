local themes = require "telescope.themes"
local zk = require "zk"

local markdown = require "ft.markdown"

vim.keymap.set("n", "<leader>mm", markdown.zk.create_note)

vim.keymap.set("x", "<leader>mr", function()
  vim.cmd { cmd = "ZkReference", args = { "title" }, mods = { keepmarks = true } }
end)

vim.keymap.set("n", "<leader>mt", function()
  zk.pick_tags({}, { title = "Notes (tags)", telescope = themes.get_dropdown {} }, function(tags)
    tags = vim.tbl_map(function(v)
      return v.name
    end, tags)
    markdown.zk.edit_with({ tags = tags }, { title = ("Notes (tagged with %s)"):format(vim.inspect(tags)) })()
  end)
end)

vim.keymap.set("n", "<localleader>mm", markdown.zk.find_notes)

vim.keymap.set("x", "<localleader>mr", function()
  vim.cmd { cmd = "ZkReference", args = { "title" }, mods = { keepmarks = true } }
end)


