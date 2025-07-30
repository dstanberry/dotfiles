local create = function() ds.ft.markdown.zk.new() end
local edit = function() ds.ft.markdown.zk.edit() end
local live_grep = function() ds.ft.markdown.zk.live_grep() end

local new_from_selection = function(where) ds.ft.markdown.zk.new_from_selection { location = where } end
local title_from_selected = function() new_from_selection "title" end
local content_from_selected = function() new_from_selection "content" end

local edit_links = function()
  ds.ft.markdown.zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (links)" })
end

local edit_backlinks = function()
  ds.ft.markdown.zk.edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (backlinks)" })
end

local edit_tags = function()
  ds.ft.markdown.zk.pick_tags({}, { title = "Notes (tags)" }, function(tags)
    tags = vim.tbl_map(function(v) return v.name end, tags)
    ds.ft.markdown.zk.edit({ tags = tags }, { title = ("Notes (tagged with: %s)"):format(vim.inspect(tags)) })
  end)
end

return {
  ["<leader>mg"] = { live_grep, "zk: find in notes (grep)" },
  ["<leader>ml"] = { edit_links, "zk: find notes (links)" },
  ["<leader>mm"] = { create, "zk: create note" },
  ["<leader>mr"] = { title_from_selected, "zk: create note (using selection as title)", "x" },
  ["<leader>mt"] = { edit_tags, "zk: find notes (tags)" },

  ["<localleader>ml"] = { edit_backlinks, "zk: find notes (backlinks)" },
  ["<localleader>mm"] = { edit, "zk: edit note(s)" },
  ["<localleader>mr"] = { content_from_selected, "zk: create note (using selection as content)", "x" },
}
