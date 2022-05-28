local data = require "ui.statusline.data"
local hi = require "ui.statusline.highlight"
local lsp = require "ui.statusline.lsp"
local views = require "ui.statusline.views"
local add = require("ui.statusline.helper").add
local icons = require "ui.icons"

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

local function spacer()
  return add(hi.custom0, { " " })
end

local function default(state, bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  local diagnostics = lsp.get_diagnostics(bufnr)
  if state == "active" then
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(mode_hl, { data.git_branch(bufnr) }),
      add(hi.custom0, { vim.b.gitsigns_status }),
      -- spacer(),
      -- add(hi.user1, { data.relpath(bufnr) }, true),
      -- spacer(),
      -- add(hi.user2, { data.filename(bufnr), data.modified(bufnr) }),
      spacer(),
      add(hi.custom0, {
        hi.custom0,
        pad(icons.status.Error, "right"),
        diagnostics.error,
        hi.custom0,
        pad(icons.status.Warn, "both"),
        diagnostics.warn,
      }, true),
      spacer(),
      hi.segment,
      -- spacer(),
      -- add(hi.user3, { lsp.get_messages(bufnr) }, true),
      spacer(),
      add(hi.custom0, { data.cursor_position() }),
      spacer(),
      add(hi.custom0, { data.readonly(bufnr), data.file_encoding(bufnr) }),
      spacer(),
      add(hi.custom0, { data.file_format(bufnr) }),
      spacer(),
      add(hi.custom0, { data.filetype(bufnr) }),
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

local function plugin(state, bufnr, t)
  local term = t or false
  if state == "active" then
    local mode = vim.fn.mode()
    local mode_hl = hi.mode(mode)
    return table.concat {
      add(mode_hl, { data.mode() }),
      add(mode_hl, { term and "term://" or "", data.filename(bufnr) }, true),
      hi.segment,
    }
  else
    return table.concat {
      add(hi.user3, { " ", term and "term://" or "", data.filename(bufnr) }, true),
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
      -- add(hi.custom0, { data.readonly(bufnr), data.file_encoding(bufnr), data.file_format(bufnr) }),
      -- add(mode_hl, { data.filetype(bufnr) }),
      -- add(hi.user4, { " ", data.cursor_position() }),
      spacer(),
      add(hi.custom0, { data.cursor_position() }),
      spacer(),
      add(hi.custom0, { data.readonly(bufnr), data.file_encoding(bufnr) }),
      spacer(),
      add(hi.custom0, { data.file_format(bufnr) }),
      spacer(),
      add(hi.custom0, { data.filetype(bufnr) }),
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
  if contains(views.terminal, name) then
    return plugin(state, bufnr, true)
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
  if contains(views.terminal, name) then
    return plugin(state, bufnr, true)
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
  vim.api.nvim_create_augroup("statusline", { clear = true })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = "statusline",
    callback = function()
      vim.wo.statusline = string.format(
        [[%%!luaeval('require("ui.statusline").focus(%s)')]],
        vim.api.nvim_get_current_win()
      )
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = "statusline",
    pattern = "TelescopePrompt",
    callback = function()
      vim.wo.statusline = string.format(
        [[%%!luaeval('require("ui.statusline").dim(%s)')]],
        vim.api.nvim_get_current_win()
      )
    end,
  })

  vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = "statusline",
    callback = function()
      vim.wo.statusline = string.format(
        [[%%!luaeval('require("ui.statusline").dim(%s)')]],
        vim.api.nvim_get_current_win()
      )
    end,
  })
end

return M
