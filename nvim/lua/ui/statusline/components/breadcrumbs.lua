local has_devicons, devicons = pcall(require, "nvim-web-devicons")
local navic = require "remote.navic"
local add = require("ui.statusline.helper").add
local highlight = require "ui.statusline.highlight"
local icons = require "ui.icons"

local M = require("ui.statusline.components._class"):extend()

local default_options = {
  separator = pad(icons.misc.ChevronRight, "right"),
  maxlen = 60,
}

local separator = has "win32" and [[\]] or "/"
local txt_hl = highlight.sanitize "Winbar"
local reset_hl = highlight.reset

local get_relpath = function(winid, name, maxlen)
  local path = vim.fn.fnamemodify(name, ":~:.:h:p")
  if path == "" or path == "." then
    return ""
  else
    maxlen = math.min(maxlen, math.floor(0.4 * vim.fn.winwidth(winid)))
    path = path:gsub("/$", "") .. separator
    if #name > maxlen then
      return ""
    end
    return path
  end
end

local get_file_sections = function(path, fname, ext, sep)
  local parts = #path > 0 and vim.split(path, separator) or {}
  local segments = {}
  local section

  table.insert(parts, fname)

  for k, v in ipairs(parts) do
    if #v > 0 then
      local icon, icon_hl = devicons.get_icon(fname, ext, { default = true })
      if #segments == 0 then
        if k == #parts and has_devicons then
          section = add(highlight.sanitize(icon_hl), { pad(icon, "both") }, true) .. add(txt_hl, { v })
        else
          section = add(txt_hl, { pad(v, "left") })
        end
      else
        if k == #parts and has_devicons then
          section = add(highlight.sanitize(icon_hl), { pad(icon, "right") }, true) .. add(txt_hl, { v })
        else
          section = add(txt_hl, { v })
        end
      end
      table.insert(segments, section)
    end
  end
  return table.concat(segments, sep)
end

local get_lsp_symbols = function(sep)
  if not navic.is_available() then
    return ""
  end

  local symbols = navic.get_data()
  if symbols == nil then
    return ""
  end

  local segments = {}
  local depth = #symbols
  local section

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    if #segments == 0 then
      section = add(txt_hl, { sep }, true)
        .. add(highlight.sanitize(("NavicIcons%s"):format(symbol.type)), { symbol.icon }, true)
        .. add(txt_hl, { symbol.name })
    else
      section = add(highlight.sanitize(("NavicIcons%s"):format(symbol.type)), { symbol.icon }, true)
        .. add(txt_hl, { symbol.name })
    end
    table.insert(segments, section)
  end

  return table.concat(segments, sep)
end

local get_diff_section = function(bufnr)
  return add(highlight.sanitize "Title", { vim.api.nvim_buf_get_var(bufnr, "diffview_label") }, true)
end

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:load()
  local fname = (self.options.name):match "^.+/(.+)$"
  local _, bufid = pcall(vim.api.nvim_buf_get_var, self.options.buf, "bufid")
  local is_diff = vim.startswith(bufid, "diffview")
  local path = is_diff and "" or get_relpath(self.options.winid, self.options.name, self.options.maxlen)
  local ext = vim.fn.fnamemodify(fname, ":e")
  local file_sections = get_file_sections(path, fname, ext, self.options.separator)
  if is_diff then
    local diff_section = get_diff_section(self.options.buf)
    self.label = string.format("%s%s%s%s", diff_section, diff_section and "" or " ", file_sections, reset_hl)
  else
    local symbol_sections = get_lsp_symbols(self.options.separator)
    self.label = string.format("%s%s%s%s", file_sections, symbol_sections and "" or " ", symbol_sections, reset_hl)
  end
end

return M