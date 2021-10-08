local hi = require "ui.statusline.highlight"
local data = require "ui.statusline.data"
local lsp = require "ui.statusline.lsp"

local browsers = {
  "lir",
}

local plugins = {
  "Neogit",
  "packer",
  "qf",
  "TelescopePrompt",
}

local special = {
  "help",
}

local uri = {
  "man",
}

local M = {}

local function add(highlight, items, conjoin)
  local out = ""
  conjoin = conjoin or nil
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        if conjoin then
          out = string.format("%s%s", out, item)
        else
          out = string.format("%s %s", out, item)
        end
      end
    end
  end
  if conjoin then
    return string.format("%s%s", highlight, out)
  else
    return string.format("%s%s ", highlight, out)
  end
end

local function diag(bufnr, hl, prefix, count)
  local clients = #vim.lsp.buf_get_clients(bufnr)
  if clients == 0 or count == 0 then
    return ""
  end
  return string.format("%s%s%s", hl, prefix, count)
end

local function active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  local diagnostics = lsp.get_diagnostics(bufnr)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(mode_hl, { data.git_branch(bufnr) }),
    add(hi.user1, { data.relpath(bufnr) }, true),
    add(hi.user2, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
    add(hi.user3, { lsp.get_messages(bufnr) }, true),
    add(hi.custom0, {
      diag(bufnr, hi.lsp_error, " ", diagnostics.error),
      diag(bufnr, hi.lsp_warn, "𥉉", diagnostics.warn),
      diag(bufnr, hi.lsp_hint, " ", diagnostics.hint),
      diag(bufnr, hi.lsp_info, " ", diagnostics.info),
    }),
    add(hi.custom00, { data.get_readonly(bufnr), data.metadata(bufnr) }),
    add(mode_hl, { data.filetype(bufnr) }),
    add(hi.user4, { " ", data.line_number(), data.column_number() }),
  }
end

local function inactive(bufnr)
  return table.concat {
    add(hi.user3, { " ", data.relpath(bufnr) }, true),
    add(hi.user3, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
  }
end

local function explorer_active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(hi.user1, { " ", data.relpath(bufnr) }, true),
    hi.segment,
  }
end

local function explorer_inactive(bufnr)
  return table.concat {
    add(hi.user3, { " ", data.relpath(bufnr) }, true),
    hi.segment,
  }
end

local function plugin_active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(mode_hl, { data.filename(bufnr) }),
    hi.segment,
  }
end

local function plugin_inactive(bufnr)
  return table.concat {
    add(hi.user3, { " ", data.filename(bufnr) }, true),
    hi.segment,
  }
end

local function special_active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(hi.user1, { " ", data.relpath(bufnr) }, true),
    add(hi.user2, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
  }
end

local function special_inactive(bufnr)
  return table.concat {
    add(hi.user3, { " ", data.filepath(bufnr) }, true),
    hi.segment,
  }
end

local function uri_active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(hi.user1, { " ", data.relpath(bufnr), "/" }, true),
    add(hi.user2, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
  }
end

local function uri_inactive(bufnr)
  return table.concat {
    add(hi.user3, { " ", data.filepath(bufnr) }, true),
    hi.segment,
  }
end

local function simple_active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  return table.concat {
    add(mode_hl, { data.mode() }, true),
    add(mode_hl, { data.git_branch(bufnr) }),
    add(hi.user2, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
    add(hi.custom00, { data.get_readonly(bufnr), data.metadata(bufnr) }),
    add(mode_hl, { data.filetype(bufnr) }),
    add(hi.user4, { " ", data.line_number(), data.column_number() }),
  }
end

local function simple_inactive()
  return hi.segment
end

M.focus = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple_inactive()
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  for _, t in ipairs(browsers) do
    if type == t then
      return explorer_active(bufnr)
    end
  end
  for _, t in ipairs(plugins) do
    local match = string.match(type, t) or ""
    if type == t or #match > 0 then
      return plugin_active(bufnr)
    end
  end
  for _, t in ipairs(special) do
    if type == t then
      return special_active(bufnr)
    end
  end
  for _, t in ipairs(uri) do
    if type == t then
      return uri_active(bufnr)
    end
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  local name = vim.fn.bufname(bufnr)
  local line = ""
  if type == "file" or #name > 0 then
    line = active(bufnr)
  else
    line = simple_active(bufnr)
  end
  return line
end

M.dim = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple_inactive()
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local name = vim.fn.bufname(bufnr)
  for _, t in ipairs(browsers) do
    if type == t then
      return explorer_inactive(bufnr)
    end
  end
  for _, t in ipairs(plugins) do
    local match = string.match(type, t) or ""
    if type == t or #match > 0 then
      return plugin_inactive(bufnr)
    end
  end
  for _, t in ipairs(special) do
    if type == t then
      return special_inactive(bufnr)
    end
  end
  for _, t in ipairs(uri) do
    if type == t then
      return uri_inactive(bufnr)
    end
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  if type == "file" or #name > 0 then
    return inactive(bufnr)
  else
    return simple_inactive()
  end
end

M.setup = function()
  require("util").define_augroup {
    name = "statusline",
    clear = true,
    autocmds = {
      {
        event = { "FocusGained", "BufEnter", "BufWinEnter" },
        pattern = "*",
        callback = function()
          vim.wo.statusline = [[%!luaeval('require("ui.statusline").focus(vim.api.nvim_get_current_win())')]]
        end,
      },
      {
        event = { "FocusLost", "BufLeave", "WinLeave" },
        pattern = "*",
        callback = function()
          vim.wo.statusline = [[%!luaeval('require("ui.statusline").dim(vim.api.nvim_get_current_win())')]]
        end,
      },
    },
  }
end

return M
