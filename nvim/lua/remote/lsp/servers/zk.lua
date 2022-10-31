local ok, zk = pcall(require, "zk")
if not ok then
  return
end

local zku = require "zk.util"

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

M.config = {
  -- cmd = { "zk", "lsp", "--log", "/tmp/zk-lsp.log" },
  cmd = { "zk", "lsp" },
  name = "zk",
}

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
    lsp = { config = cfg },
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  }

  vim.api.nvim_create_user_command("ZkOrphans", function()
    M.edit_with({ orphan = true }, { title = "Notes (orphaned)" })
  end, {})
  vim.api.nvim_create_user_command("ZkRecent", function()
    M.edit_with({ createdAfter = "2 weeks ago" }, { title = "Notes (recent)" })
  end, {})
  vim.api.nvim_create_user_command("ZkDaily", function()
    M.edit_with({ hrefs = { "journal" }, sort = { "created" } }, { title = "Notes (journal)" })
  end, {})
  vim.api.nvim_create_user_command("ZkMeeting", function()
    M.edit_with({ hrefs = { "inbox" }, sort = { "created" } }, { title = "Notes (inbox)" })
  end, {})
  vim.api.nvim_create_user_command("ZkResource", function()
    M.edit_with({ hrefs = { "resources" }, sort = { "created" } }, { title = "Notes (resources)" })
  end, {})
  vim.api.nvim_create_user_command("ZkResource", function(opts)
    local options = opts.fargs and unpack(opts.fargs) or {}
    local notebook_path = options.notebook_path or zku.resolve_notebook_path(0)
    local notebook_root = zku.notebook_root(notebook_path)
    assert(notebook_root ~= nil and #notebook_root > 0, "No notebook found.")
    telescope.live_grep { cwd = notebook_root, prompt_title = "Notes (live grep)" }
  end, {})
  vim.api.nvim_create_user_command("ZkReference", function(opts)
    local cmd = unpack(opts.fargs)
    if cmd == "content" then
      markdown.zk.create_reference_with_title()
    elseif cmd == "title" then
      markdown.zk.create_reference_with_content()
    else
      error(("Invalid option to create reference: '%s'"):format(cmd))
    end
  end, {
    nargs = "?",
    range = true,
    force = true,
    complete = function(_, line)
      local l = vim.split(line, "%s+")
      local n = #l - 2
      if n == 0 then
        return vim.tbl_filter(function(val)
          return vim.startswith(val, l[2])
        end, { "content", "title" })
      end
    end,
  })
  vim.api.nvim_create_user_command("ZkInsertLink", function(opts)
    local options = opts.fargs and unpack(opts.fargs) or {}
    zk.pick_notes(options, { title = "Notes (insert link to note)", multi_select = false }, function(notes)
      local pos = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local pwd = vim.fn.expand "%:p:h:t"
      notes = { notes }
      for _, note in ipairs(notes) do
        local npath = note.path
        if pwd ~= npath then
          npath = ("../%s"):format(npath)
        end
        local updated = ("%s[%s](%s)%s"):format(line:sub(0, pos), note.title, npath:sub(1, -6), line:sub(pos + 1))
        vim.api.nvim_set_current_line(updated)
      end
    end)
  end, {})
  vim.api.nvim_create_user_command("ZkLinkToNote", function(opts)
    local options = opts.fargs and unpack(opts.fargs) or {}
    local lines = util.buffer.get_visual_selection()
    local selection = table.concat(lines)
    zk.pick_notes(
      options,
      { title = ("Notes (link '%s' to note)"):format(selection), multi_select = false },
      function(notes)
        local pos = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local pwd = vim.fn.expand "%:p:h:t"
        notes = { notes }
        for _, note in ipairs(notes) do
          local npath = note.path
          if pwd ~= npath then
            npath = ("../%s"):format(npath)
          end
          local updated = ("%s[%s](%s)%s"):format(
            line:sub(0, pos - #selection),
            selection,
            npath:sub(1, -6),
            line:sub(pos + 1)
          )
          vim.api.nvim_set_current_line(updated)
        end
      end
    )
  end, { range = true })

  vim.keymap.set("n", "<leader>mm", markdown.zk.create_note)
  vim.keymap.set("n", "<leader>mt", function()
    zk.pick_tags({}, { title = "Notes (tags)", telescope = themes.get_dropdown {} }, function(tags)
      tags = vim.tbl_map(function(v)
        return v.name
      end, tags)
      M.edit_with({ tags = tags }, { title = ("Notes (tagged with %s)"):format(vim.inspect(tags)) })()
    end)
  end)
  vim.keymap.set("x", "<leader>mr", function()
    vim.cmd { cmd = "ZkReference", args = { "title" }, mods = { keepmarks = true } }
  end)

  vim.keymap.set("n", "<localleader>mm", markdown.zk.find_notes)
  vim.keymap.set("x", "<localleader>mr", function()
    vim.cmd { cmd = "ZkReference", args = { "title" }, mods = { keepmarks = true } }
  end)

  pcall(telescope.load_extension, "zk")
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
