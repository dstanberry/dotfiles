-- verify terminal instance is windows terminal
if not (vim.env.WT_SESSION or pcall(require, "nvim-treesitter-playground")) then
  return
end

local groups = require "ui.theme.groups"
local ts_info = require "nvim-treesitter-playground.hl-info"

groups.new("WTCursorBg", { clear = true, gui = "none" })
groups.new("WTCursorFg", { clear = true, gui = "none" })

vim.opt.guicursor:append "n-v-c-sm:block-WTCursorBg"

local id = 99991

local set_cursor_hl = function()
  if vim.bo.filetype == "lir" then
    groups.new("WTCursorBg", { clear = true, guibg = "none" })
    groups.new("WTCursorFg", { clear = true, gui = "none" })
    return
  end
  local matches = vim.fn.getmatches()
  for _, h in pairs(matches) do
    if h.id == id then
      vim.fn.matchdelete(id)
    end
  end
  vim.fn.matchadd("WTCursorFg", [[\%#.]], 100, id)
  local ts_hl = ts_info.get_treesitter_hl()
  local b_hl = ts_info.get_syntax_hl()
  local hl = (next(ts_hl) and ts_hl[#ts_hl]) or (next(b_hl) and b_hl[#b_hl]) or "Normal"
  if string.match(hl, "**") then
    hl = string.gmatch(hl, "(%a+)**$")()
  end
  local hid = vim.fn.hlID(hl)
  local gid = vim.fn.synIDtrans(hid)
  local attr = vim.fn.synIDattr(gid, "fg#")
  if attr == "" then
    attr = "white"
  end
  groups.new("WTCursorBg", { clear = true, guibg = attr })
  groups.new("WTCursorFg", { clear = true, gui = "reverse" })
end

local reset_cursor_hl = function()
  if vim.bo.filetype == "lir" then
    return
  end
  local matches = vim.fn.getmatches()
  for _, h in pairs(matches) do
    if h.id == id then
      vim.fn.matchdelete(id)
    end
  end
  local hid = vim.fn.hlID "Normal"
  local gid = vim.fn.synIDtrans(hid)
  local attr = vim.fn.synIDattr(gid, "fg#")
  if attr == "" then
    attr = "white"
  end
  groups.new("WTCursorBg", { guibg = attr })
end

vim.api.nvim_create_augroup { name = "wt_reverse_cursor", clear = true }

vim.api.nvim_create_autocmd {
  group = "wt_reverse_cursor",
  event = "FocusGained",
  callback = function()
    if vim.fn.mode(1) ~= "i" then
      set_cursor_hl()
    end
  end,
}

vim.api.nvim_create_autocmd {
  group = "wt_reverse_cursor",
  event = { "CmdLineEnter", "FocusLost", "InsertEnter" },
  callback = function()
    reset_cursor_hl()
  end,
}

vim.api.nvim_create_autocmd {
  group = "wt_reverse_cursor",
  event = { "CursorMoved", "InsertLeave" },
  callback = function()
    set_cursor_hl()
  end,
}
