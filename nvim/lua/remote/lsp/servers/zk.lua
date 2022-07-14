local ok, zk = pcall(require, "zk")
if not ok then
  return
end

local zku = require "zk.util"
local zkc = require "zk.commands"

local telescope = require "remote.telescope"
local themes = require "telescope.themes"

local markdown = require "ft.markdown"
local util = require "util"

local M = {}

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = ("%s/%s"):format(path, "zk")

local win_documents_path = ("%s/Documents"):format(vim.env.HOME)
if has "win32" and vim.fn.empty(vim.fn.glob(win_documents_path)) > 0 then
  if vim.fn.empty(vim.fn.glob "D:\\Documents") == 0 then
    win_documents_path = "D:\\Documents"
  end
end

vim.g.zk_notebook = vim.env.hash_notes and ("%s/zettelkasten/vault"):format(vim.env.hash_notes)
  or ("%s/_notes/zettelkasten/vault"):format(win_documents_path)

M.edit_with = function(opts, picker_options)
  return function(options)
    options = vim.tbl_extend("force", opts, options or {})
    picker_options = vim.tbl_extend("force", picker_options, {
      telescope = themes.get_ivy {},
    })
    zk.edit(options, picker_options)
  end
end

M.setup = function(cfg)
  local install_cmd = string.format(
    [[
      git clone https://github.com/mickael-menu/zk.git
      cd zk
      make
      mkdir -vp %s/{inbox,journal,resources}
      cp zk $GOPATH/bin/
    ]],
    vim.g.zk_notebook
  )
  util.terminal.install_package("zk", basedir, path, install_cmd, false)

  zk.setup {
    picker = "telescope",
    config = cfg,
  }

  zkc.add("ZkOrphans", M.edit_with({ orphan = true }, { title = "Notes (orphaned)" }))
  zkc.add("ZkRecent", M.edit_with({ createdAfter = "2 weeks ago" }, { title = "Notes (recent)" }))
  zkc.add("ZkDaily", M.edit_with({ hrefs = { "journal" }, sort = { "created" } }, { title = "Notes (journal)" }))
  zkc.add("ZkMeeting", M.edit_with({ hrefs = { "inbox" }, sort = { "created" } }, { title = "Notes (inbox)" }))
  zkc.add("ZkResource", M.edit_with({ hrefs = { "resources" }, sort = { "created" } }, { title = "Notes (resources)" }))

  zkc.add("ZkNewReferenceFromTitleSelection", markdown.zk.create_reference_with_title, { needs_selection = true })
  zkc.add("ZkNewReferenceFromContentSelection", markdown.zk.create_reference_with_content, { needs_selection = true })
  zkc.add("ZkGrep", function(options)
    options = options or {}
    local notebook_path = options.notebook_path or zku.resolve_notebook_path(0)
    local notebook_root = zku.notebook_root(notebook_path)
    assert(notebook_root ~= nil and #notebook_root > 0, "No notebook found.")
    telescope.live_grep { cwd = notebook_root, prompt_title = "Notes (live grep)" }
  end)

  vim.keymap.set("n", "<localleader>mm", markdown.zk.find_notes)
  vim.keymap.set("n", "<leader>mm", markdown.zk.create_note)
  vim.keymap.set("n", "<localleader>mt", function()
    zk.pick_tags({}, { title = "Notes (tags)", telescope = themes.get_dropdown {} }, function(tags)
      tags = vim.tbl_map(function(v)
        return v.name
      end, tags)
      M.edit_with({ tags = tags }, { title = ("Notes (tagged with %s)"):format(vim.inspect(tags)) })()
    end)
  end)

  vim.keymap.set("n", "<localleader>mb", "<cmd>ZkBacklinks<cr>")
  vim.keymap.set("n", "<localleader>mgg", "<cmd>ZkGrep<cr>")
  vim.keymap.set("n", "<localleader>mb", "<cmd>ZkBacklinks<cr>")

  vim.keymap.set("x", "<localleader>mr", ":'<,'>ZkNewReferenceFromTitleSelection<cr>")
  vim.keymap.set("x", "<localleader>mR", ":'<,'>ZkNewReferenceFromContentSelection<cr>")

  telescope.load_extension "zk"
end

return setmetatable({}, {
  __index = function(t, k)
    if M[k] then
      return M[k]
    else
      return zk[k]
    end
  end,
})
