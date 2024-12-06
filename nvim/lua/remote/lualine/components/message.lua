---@diagnostic disable: undefined-field
---@class remote.lualine.component.message
local M = {}

local util = require "remote.lualine.util"

M.noice = {
  get = function()
    local text = require("noice").api.status.search.get()
    local query = text:match "%/(.-)%s" or text:match "%?(.-)%s" or ""
    local counter = text:match "%d+%/%d+"
    return string.format("%s %s [%s]", ds.icons.misc.Magnify, query, counter)
  end,
  cond = function()
    return package.loaded["noice"] and require("noice").api.status.search.has() and util.available_width(80)
  end,
}

return M
