---------------------------------------------------------------
-- => Statusline Configuration
---------------------------------------------------------------
-- load statusline utilities
local hi = require "ui.statusline.highlight"
local data = require "ui.statusline.data"

local browsers = {
  "lir",
}

local special = {
  "help",
}

local plugins = {
  "Neogit",
  "packer",
  "qf",
  "TelescopePrompt",
}

-- initialize modules table
local statusline = {}

-- add section to statusline
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

-- add lsp diagnostic section to statusline
local function diag(hl, prefix, count)
  local clients = data.get_lsp_client_count()
  if clients == 0 then
    return ""
  end
  local out = prefix .. count
  if count > 0 then
    return hl .. out
  end
  return out
end

-- default statusline for active windows
local function active(bufnr)
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  local diagnostics = data.get_lsp_diagnostics(bufnr)
  return table.concat {
    add(mode_hl, { data.mode() }),
    add(mode_hl, { data.git_branch(bufnr) }),
    add(hi.user1, { data.relpath(bufnr) }, true),
    add(hi.user2, { data.filename(bufnr), data.get_modified(bufnr) }),
    hi.segment,
    add(hi.custom0, {
      diag(hi.lsperror, "E:", diagnostics.errors),
      diag(hi.lspwarning, "W:", diagnostics.warnings),
    }),
    add(hi.custom00, { data.get_readonly(bufnr), data.metadata(bufnr) }),
    add(mode_hl, { data.filetype(bufnr) }),
    add(hi.user4, { " ", data.line_number(), data.column_number() }),
  }
end

-- default statusline for inactive windows
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
    add(mode_hl, { data.mode() }),
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
    add(mode_hl, { data.mode() }),
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
    add(mode_hl, { data.mode() }),
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

local function simple()
  return hi.segment
end

-- statusline when window has focus
statusline.focus = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple()
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  for _, t in ipairs(browsers) do
    if type == t then
      return explorer_active(bufnr)
    end
  end
  for _, t in ipairs(special) do
    if type == t then
      return special_active(bufnr)
    end
  end
  for _, t in ipairs(plugins) do
    local match = string.match(type, t) or ""
    if type == t or #match > 0 then
      return plugin_active(bufnr)
    end
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  local name = vim.fn.bufname(bufnr)
  local line = ""
  if type == "file" or #name > 0 then
    line = active(bufnr)
  else
    line = simple()
  end
  return line
end

-- statusline when window does not have focus
statusline.dim = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return simple()
  end
  if vim.fn.pumvisible() == 1 then
    return statusline.focus(win_id)
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local name = vim.fn.bufname(bufnr)
  for _, t in ipairs(browsers) do
    if type == t then
      return explorer_inactive(bufnr)
    end
  end
  for _, t in ipairs(special) do
    if type == t then
      return special_inactive(bufnr)
    end
  end
  for _, t in ipairs(plugins) do
    local match = string.match(type, t) or ""
    if type == t or #match > 0 then
      return plugin_inactive(bufnr)
    end
  end
  type = vim.fn.getftype(data.filepath(bufnr))
  if type == "file" or #name > 0 then
    return inactive(bufnr)
  else
    return simple()
  end
end

-- TODO: investigate a better way to do this
-- iterate all open windows and reapply statusline
statusline.check = function()
  for _, w in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
    local curwin = vim.fn.winnr()
    if w == curwin then
      vim.fn.setwinvar(
        w,
        "statusline",
        "string.format([[%%!luaeval('require(\"ui.statusline\").focus(%s)')]], vim.api.nvim_get_current_win())"
      )
    else
      vim.fn.setwinvar(
        w,
        "statusline",
        "string.format([[%%!luaeval('require(\"ui.statusline\").dim(%s)')]], vim.api.nvim_get_current_win())"
      )
    end
  end
end

-- initialize statusline
statusline.setup = function()
  vim.cmd [=[ augroup statusline ]=]
  vim.cmd [=[ autocmd! ]=]
  vim.cmd [=[  autocmd CompleteDonePre * :lua vim.wo.statusline = string.format([[%%!luaeval('require("ui.statusline").focus(%s)')]], vim.api.nvim_get_current_win()) ]=]
  vim.cmd [=[  autocmd FocusGained,BufEnter,BufWinEnter,WinEnter * :lua vim.wo.statusline = string.format([[%%!luaeval('require("ui.statusline").focus(%s)')]], vim.api.nvim_get_current_win()) ]=]
  vim.cmd [=[  autocmd FocusLost,BufLeave,BufWinLeave,WinLeave * :lua vim.wo.statusline = string.format([[%%!luaeval('require("ui.statusline").dim(%s)')]], vim.api.nvim_get_current_win()) ]=]
  vim.cmd [=[ augroup END ]=]
  vim.cmd [=[ doautocmd BufWinEnter ]=]

  vim.fn.timer_start(100, function()
    return statusline.check()
  end)
end

return statusline
