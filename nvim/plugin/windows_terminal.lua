-- verify terminal instance if windows terminal
if not (vim.env.WT_SESSION or pcall(require, "nvim-treesitter-playground")) then
  return
end

local ts_info = require "nvim-treesitter-playground.hl-info"
local util = require "util"
local groups = require "ui.theme.groups"

groups.new("WTCursorFg", { clear = true, gui = "none" })
groups.new("WTCursorBg", { clear = true, gui = "none" })

vim.opt.guicursor:append "n-v-c-sm:block-WTCursorBg"

local id = 99991

local set_cursor_hl = function()
  vim.cmd(string.format("silent! call matchdelete(%s)", id))
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
  groups.new("WTCursorBg", { clear = true, guibg = attr })
  groups.new("WTCursorFg", { clear = true, gui = "reverse" })
end

local reset_cursor_hl = function()
  vim.cmd(string.format("silent! call matchdelete(%s)", id))
  local hid = vim.fn.hlID "Normal"
  local gid = vim.fn.synIDtrans(hid)
  local attr = vim.fn.synIDattr(gid, "fg#")
  groups.new("WTCursorBg", { guibg = attr })
end

util.define_augroup {
  name = "wt_reverse_cursor",
  clear = true,
  autocmds = {
    {
      event = "FocusGained",
      callback = function()
        if vim.fn.mode(1) ~= "i" then
          set_cursor_hl()
        end
      end,
    },
    {
      event = { "CmdLineEnter", "FocusLost", "InsertEnter" },
      callback = function()
        reset_cursor_hl()
      end,
    },
    {
      event = { "CursorMoved", "InsertLeave" },
      callback = function()
        set_cursor_hl()
      end,
    },
  },
}
