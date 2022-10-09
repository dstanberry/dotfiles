-- verify gitsigns is available
local ok, signs = pcall(require, "gitsigns")
if not ok then
  return
end

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

signs.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = icons.misc.VerticalBarThin },
    change = { hl = "GitSignsChange", text = icons.misc.VerticalBarThin },
    delete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
    topdelete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
    changedelete = { hl = "GitSignsDelete", text = icons.misc.VerticalBar },
  },
  status_formatter = function(status)
    local added = ""
    local changed = ""
    local removed = ""
    if status.added and status.added > 0 then
      added = pad(icons.git.TextAdded, "right") .. status.added
    end
    if status.changed and status.changed > 0 then
      changed = pad(icons.git.TextChanged, "both") .. status.changed
    end
    if status.removed and status.removed > 0 then
      removed = pad(icons.git.TextRemoved, "both") .. status.removed
    end
    return added .. changed .. removed
  end,
  numhl = false,
  update_debounce = 1000,
  current_line_blame = false,
  current_line_blame_formatter = icons.git.Commit .. " <author>, <author_time:%R>",
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 150,
  },
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        signs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        signs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "<leader>hs", signs.stage_hunk)
    map("n", "<leader>hu", signs.undo_stage_hunk)
    map("n", "<leader>hr", signs.reset_hunk)
    map("n", "<leader>hp", signs.preview_hunk)
    map("n", "<leader>hb", signs.toggle_current_line_blame)
    map("n", "<leader>hB", function()
      signs.blame_line { full = true }
    end)
  end,
}

groups.new("GitSignsAdd", { fg = c.green, bg = c.bg })
groups.new("GitSignsChange", { fg = c.yellow, bg = c.bg })
groups.new("GitSignsDelete", { fg = c.red, bg = c.bg })
groups.new("GitSignsChangeDelete", { fg = c.orange, bg = c.bg })
groups.new("GitSignsCurrentLineBlame", { fg = c.gray_light, italic = true })
