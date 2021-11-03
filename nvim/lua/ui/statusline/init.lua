local util = require "util"

local data = require "ui.statusline.data"
local hi = require "ui.statusline.highlight"
local lsp = require "ui.statusline.lsp"
local views = require "ui.statusline.views"

local function contains(haystack, value)
  local found = false
  for _, v in pairs(haystack) do
    local match = string.match(value, v) or ""
    if v == value or #match > 0 then
      found = true
      break
    end
  end
  return found
end

local function add(highlight, items, join)
  local out = ""
  join = join or nil
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        out = join and string.format("%s%s", out, item) or string.format("%s %s", out, item)
      end
    end
  end
  return join and string.format("%s%s", highlight, out) or string.format("%s%s ", highlight, out)
end

local function collapse_diag(hl, prefix, count)
  return count > 0 and string.format("%s%s%s", hl, prefix, count) or ""
end

local function default(state, bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  local diagnostics = lsp.get_diagnostics(bufnr)
  if state == "active" then
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(mode_hl, { data.git_branch(bufnr) }),
      add(hi.user1, { data.relpath(bufnr) }, true),
      add(hi.user2, { data.filename(bufnr), data.modified(bufnr) }),
      hi.segment,
      add(hi.user3, { lsp.get_messages(bufnr) }, true),
      add(hi.custom0, {
        collapse_diag(hi.lsp_error, " ", diagnostics.error),
        collapse_diag(hi.lsp_warn, " ", diagnostics.warn),
        collapse_diag(hi.lsp_hint, " ", diagnostics.hint),
        collapse_diag(hi.lsp_info, " ", diagnostics.info),
      }),
      add(hi.custom00, { data.readonly(bufnr), data.metadata(bufnr) }),
      add(mode_hl, { data.filetype(bufnr) }),
      add(hi.user4, { " ", data.line_number(), data.column_number() }),
    }
  else
    return table.concat {
      add(hi.user3, { " ", data.relpath(bufnr) }, true),
      add(hi.user3, { data.filename(bufnr), data.modified(bufnr) }),
      hi.segment,
    }
  end
end

local function explorer(state, bufnr)
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(hi.user1, { " ", data.relpath(bufnr) }, true),
      hi.segment,
    }
  else
    return table.concat {
      add(hi.user3, { " ", data.relpath(bufnr) }, true),
      hi.segment,
    }
  end
end

local function plugin(state, bufnr)
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(mode_hl, { data.filename(bufnr) }),
      hi.segment,
    }
  else
    return table.concat {
      add(hi.user3, { " ", data.filename(bufnr) }, true),
      hi.segment,
    }
  end
end

local function basic(state, bufnr)
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(hi.user1, { " ", data.relpath(bufnr) }, true),
      add(hi.user2, { data.filename(bufnr), data.modified(bufnr) }),
      hi.segment,
    }
  else
    return table.concat {
      add(hi.user3, { " ", data.filepath(bufnr) }, true),
      hi.segment,
    }
  end
end

local function uri(state, bufnr)
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(hi.user1, { " ", data.relpath(bufnr), "/" }, true),
      add(hi.user2, { data.filename(bufnr), data.modified(bufnr) }),
      hi.segment,
    }
  else
    return table.concat {
      add(hi.user3, { " ", data.filepath(bufnr) }, true),
      hi.segment,
    }
  end
end

local function simple(state, bufnr)
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(mode_hl, { data.git_branch(bufnr) }),
      add(hi.user2, { data.filename(bufnr), data.modified(bufnr) }),
      hi.segment,
      add(hi.custom00, { data.readonly(bufnr), data.metadata(bufnr) }),
      add(mode_hl, { data.filetype(bufnr) }),
      add(hi.user4, { " ", data.line_number(), data.column_number() }),
    }
  else
    return hi.segment
  end
end

local M = {}

M.focus = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple("inactive", _)
  end
  local state = "active"
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local name = vim.fn.bufname(bufnr)
  if contains(views.browsers, type) then
    return explorer(state, bufnr)
  end
  if contains(views.plugins, type) or contains(views.filenames, name) then
    return plugin(state, bufnr)
  end
  if contains(views.basic, type) then
    return basic(state, bufnr)
  end
  if contains(views.uri, type) then
    return uri(state, bufnr)
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  if type == "file" or #name > 0 then
    return default(state, bufnr)
  else
    return simple(state, bufnr)
  end
end

M.dim = function(win_id)
  local state = "inactive"
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple(state, _)
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local name = vim.fn.bufname(bufnr)
  if contains(views.browsers, type) then
    return explorer(state, bufnr)
  end
  if contains(views.plugins, type) or contains(views.filenames, name) then
    return plugin(state, bufnr)
  end
  if contains(views.basic, type) then
    return basic(state, bufnr)
  end
  if contains(views.uri, type) then
    return uri(state, bufnr)
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  if type == "file" or #name > 0 then
    return default(state, bufnr)
  else
    return simple(state, bufnr)
  end
end

M.setup = function()
  util.define_augroup {
    name = "statusline",
    clear = true,
    autocmds = {
      {
        event = { "FocusGained", "BufEnter", "BufWinEnter" },
        pattern = "*",
        command = [=[ lua vim.wo.statusline = string.format([[%%!luaeval('require("ui.statusline").focus(%s)')]], vim.api.nvim_get_current_win()) ]=],
      },
      {
        event = { "FocusLost", "BufLeave", "WinLeave" },
        pattern = "*",
        command = [=[ lua vim.wo.statusline = string.format([[%%!luaeval('require("ui.statusline").dim(%s)')]], vim.api.nvim_get_current_win()) ]=],
      },
    },
  }
end

return M
