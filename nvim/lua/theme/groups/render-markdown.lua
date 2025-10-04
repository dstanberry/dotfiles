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

    -- `NormalFloat` overrides
    NormalFloatH1            = { fg = c.bg0 },
    NormalFloatH1Bg          = { fg = c.bg0, bg = c.blue1 },
    NormalFloatH2            = { fg = c.bg0 },
    NormalFloatH2Bg          = { fg = c.bg0, bg = c.blue1 },
    NormalFloatH3            = { fg = c.bg0 },
    NormalFloatH3Bg          = { fg = c.bg0, bg = c.blue1 },
    NormalFloatH4            = { fg = c.bg0 },
    NormalFloatH4Bg          = { fg = c.bg0, bg = c.blue1 },
    NormalFloatH5            = { fg = c.bg0 },
    NormalFloatH5Bg          = { fg = c.bg0, bg = c.blue1 },
    NormalFloatH6            = { fg = c.bg0 },
    NormalFloatH6Bg          = { fg = c.bg0, bg = c.blue1 },

    RenderMarkdownCodeBorder = { bg = ds.color.darken(c.blue1, 65), bold = true },
  }
end

return M
