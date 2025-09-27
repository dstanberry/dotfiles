local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- mini.files
    MiniFilesBorder         = { link = "FloatBorder" },
    MiniFilesBorderModified = { fg = c.rose0, bg = c.bg0 },
    MiniFilesCursorLine     = { bg = c.bg0 },
    MiniFilesTitle          = { fg = c.gray2, bg = c.bg0 },
    MiniFilesTitleFocused   = { fg = c.blue1, bg = c.bg0 },

    -- mini.icons
    MiniIconsYellow         = { fg = c.yellow0 },
    MiniIconsPurple         = { fg = c.purple0 },
    MiniIconsOrange         = { fg = c.orange0 },
    MiniIconsGreen          = { fg = c.green0 },
    MiniIconsAzure          = { fg = c.aqua0 },
    MiniIconsGrey           = { fg = c.overlay1 },
    MiniIconsCyan           = { fg = c.cyan0 },
    MiniIconsBlue           = { fg = c.blue0 },
    MiniIconsRed            = { fg = c.rose0 },

    -- mini.indentscope
    MiniIndentscopeSymbol   = { link = "@punctuation.bracket" }
}
end

return M
