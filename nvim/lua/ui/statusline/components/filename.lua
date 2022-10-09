local M = require("ui.statusline.components._class"):extend()

local default_options = {
  symbols = {
    modified = "[+]",
    readonly = "[-]",
    unnamed = "[No Name]",
    newfile = "[New]",
  },
  absolute = false,
  relative = false,
  file_status = true,
  newfile_status = false,
  viewport = 40,
}

local is_new_file = function(bufnr)
  local filename = vim.fn.expand "%"
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  return filename ~= "" and buftype == "" and vim.fn.filereadable(filename) == 0
end

local shorten_path = function(path, sep, max_len)
  local len = #path
  if len <= max_len then
    return path
  end

  local segments = vim.split(path, sep)
  for idx = 1, #segments - 1 do
    if len <= max_len then
      break
    end

    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
    segments[idx] = shortened
    len = len - (#segment - #shortened)
  end

  return table.concat(segments, sep)
end

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:load()
  self.label = ""
  local data
  if self.options.relative then
    data = vim.fn.expand "%:~:."
  elseif self.options.absolute then
    data = vim.fn.expand "%:p:~"
  else
    data = vim.fn.expand "%:t"
  end

  if not data or data == "" then
    data = self.options.symbols.unnamed
  end

  if self.options.viewport ~= 0 then
    local windwidth = self.options.globalstatus and vim.go.columns or vim.fn.winwidth(0)
    local estimated_space_available = windwidth - self.options.viewport

    local separator = has "win32" and [[\]] or "/"
    data = shorten_path(data, separator, estimated_space_available)
  end

  local symbols = {}
  if self.options.file_status then
    local modified = vim.api.nvim_buf_get_option(self.options.buf, "modified")
    local modifiable = vim.api.nvim_buf_get_option(self.options.buf, "modifiable")
    local readonly = vim.api.nvim_buf_get_option(self.options.buf, "readonly")
    if modified then
      table.insert(symbols, self.options.symbols.modified)
    end
    if modifiable == false or readonly == true then
      table.insert(symbols, self.options.symbols.readonly)
    end
  end

  if self.options.newfile_status and is_new_file(self.options.buf) then
    table.insert(symbols, self.options.symbols.newfile)
  end
  self.label = data .. (#symbols > 0 and " " .. table.concat(symbols, "") or "")
end

return M
