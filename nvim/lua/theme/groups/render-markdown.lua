local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    RenderMarkdownH1         = { fg = c.bg2 },
    RenderMarkdownH1Bg       = { fg = c.bg2, bg = c.blue1 },
    RenderMarkdownH2         = { fg = c.bg2 },
    RenderMarkdownH2Bg       = { fg = c.bg2, bg = c.blue1 },
    RenderMarkdownH3         = { fg = c.bg2 },
    RenderMarkdownH3Bg       = { fg = c.bg2, bg = c.blue1 },
    RenderMarkdownH4         = { fg = c.bg2 },
    RenderMarkdownH4Bg       = { fg = c.bg2, bg = c.blue1 },
    RenderMarkdownH5         = { fg = c.bg2 },
    RenderMarkdownH5Bg       = { fg = c.bg2, bg = c.blue1 },
    RenderMarkdownH6         = { fg = c.bg2 },
    RenderMarkdownH6Bg       = { fg = c.bg2, bg = c.blue1 },

    -- `codecompanion` overrides
    RenderMarkdownCcH1         = { fg = c.bg0 },
    RenderMarkdownCcH1Bg       = { fg = c.bg0, bg = c.blue1 },
    RenderMarkdownCcH2         = { fg = c.bg0 },
    RenderMarkdownCcH2Bg       = { fg = c.bg0, bg = c.blue1 },
    RenderMarkdownCcH3         = { fg = c.bg0 },
    RenderMarkdownCcH3Bg       = { fg = c.bg0, bg = c.blue1 },
    RenderMarkdownCcH4         = { fg = c.bg0 },
    RenderMarkdownCcH4Bg       = { fg = c.bg0, bg = c.blue1 },
    RenderMarkdownCcH5         = { fg = c.bg0 },
    RenderMarkdownCcH5Bg       = { fg = c.bg0, bg = c.blue1 },
    RenderMarkdownCcH6         = { fg = c.bg0 },
    RenderMarkdownCcH6Bg       = { fg = c.bg0, bg = c.blue1 },

    RenderMarkdownCodeBorder = { bg = ds.color.darken(c.blue1, 65), bold = true },
  }
end

return M
