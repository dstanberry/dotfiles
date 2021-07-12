---------------------------------------------------------------
-- => Statusline Configuration
---------------------------------------------------------------
-- load statusline utilities
local log = require "statusline.log"
local hi = require "statusline.highlight"
local util = require "statusline.util"

-- only show relpath in statusline for these filetypes
local fp = {
  "help",
  "lir",
  "netrw",
}

-- only show filetype in statusline for these filetypes
local ft = {
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
  local out = prefix .. count
  if count > 0 then
    return hl .. out
  end
  return out
end

-- default statusline for active windows
local function active()
  local mode = vim.fn.mode()
  local mode_hl = hi.mode(mode)
  local diagnostics = util.get_lsp_diagnostics()
  return table.concat {
    add(mode_hl, { util.mode() }),
    add(mode_hl, { util.git_branch() }),
    add(hi.user1, { util.relpath() }, true),
    add(hi.user2, { util.filename(), util.get_modified() }),
    hi.segment,
    add(hi.custom0, {
      diag(hi.lsperror, "E:", diagnostics.errors),
      diag(hi.lspwarning, "W:", diagnostics.warnings),
    }),
    add(hi.custom00, { util.get_readonly(), util.metadata() }),
    add(mode_hl, { util.filetype() }),
    add(hi.user4, { " ", util.line_number(), util.column_number() }),
  }
end

-- default statusline for inactive windows
local function inactive()
  return table.concat {
    add(hi.user3, { util.relpath() }, true),
    add(hi.user3, { util.filename(), util.get_modified() }),
    hi.segment,
  }
end

-- default statusline for file explorers
local function explorer()
  return table.concat {
    add(hi.user3, { util.relpath() }, true),
    hi.segment,
  }
end

-- default statusline for various plugins
local function plugin()
  return table.concat {
    add(hi.user3, { string.format("[%s]", util.filetype()) }, true),
    hi.segment,
  }
end

-- default statusline for exotic windows
local function simple()
  return hi.segment
end
-- statusline when window has focus
statusline.focus = function(win_id)
  local line = ""
  if not vim.api.nvim_win_is_valid(win_id) then
    return
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  for _, t in ipairs(fp) do
    if type == t then
      line = explorer()
    end
  end
  for _, t in ipairs(ft) do
    if type == t then
      line = plugin()
    end
  end
  type = vim.fn.getftype(util.filepath())
  if type == "file" then
    line = active()
  else
    line = simple()
  end
  log.debug("setting statusline to:", line)
  return line
end

-- statusline when window does not have focus
statusline.dim = function(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return
  end
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  type = vim.fn.getftype(util.filepath())
  if type == "file" then
    return inactive()
  end
end

-- initialize statusline
statusline.setup = function()
  vim.cmd [=[augroup statusline]=]
  vim.cmd [=[  autocmd!]=]
  vim.cmd [=[  autocmd BufWinEnter,WinEnter,FocusGained * :lua vim.wo.statusline = string.format([[%%!luaeval('require("statusline").focus(%s)')]], vim.api.nvim_get_current_win()) ]=]
  vim.cmd [=[  autocmd BufWinLeave,WinLeave,FocusLost * :lua vim.wo.statusline = string.format([[%%!luaeval('require("statusline").dim(%s)')]], vim.api.nvim_get_current_win()) ]=]
  vim.cmd [=[augroup END]=]

  vim.cmd [[doautocmd BufWinEnter]]
end

return statusline
