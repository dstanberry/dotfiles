local function create() ds.ft.markdown.zk.new() end
local function edit() ds.ft.markdown.zk.edit() end
local function live_grep() ds.ft.markdown.zk.live_grep() end

local function new_from_selection(where) ds.ft.markdown.zk.new_from_selection { location = where } end
local function title_from_selected() new_from_selection "title" end
local function content_from_selected() new_from_selection "content" end

local function edit_links()
  ds.ft.markdown.zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (links)" })
end

local function edit_backlinks()
  ds.ft.markdown.zk.edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { title = "Notes (backlinks)" })
end

local function edit_tags()
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
