local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local highlighter = require "ui.statusline.highlighter"
local icons = require "ui.icons"

local M = require("ui.statusline.components._class"):extend()

local default_options = {
  unnamed = "[No Name]",
  colored = true,
  icon_only = false,
  text_only = false,
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:load()
  self.label = #self.options.filetype > 0 and self.options.filetype or self.options.unnamed
  if self.options.text_only then return end
  local icon, icon_highlight
  if has_devicons then
    local fname = (self.options.name):match "^.+/(.+)$"
    local ext = vim.fn.fnamemodify(fname, ":e")
    icon, icon_highlight = devicons.get_icon(fname, ext)
    if icon == nil and icon_highlight == nil then
      icon = icons.documents.File
      icon_highlight = "DevIconDefault"
    end
  end
  if self.options.icon_only then
    self.label = icon
  else
    self.label = ("%s %s"):format(icon, self.label)
  end
  if self.options.colored then
    -- TODO: fix bg color issue
    self.label = ("%s%s"):format(highlighter.sanitize(icon_highlight), self.label)
  end
end

return M
