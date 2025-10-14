local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local RED = ds.color.blend(ds.color.lighten(c.red2, 20), c.red1, 0.7)
  local ORANGE = ds.color.blend(ds.color.lighten(c.orange1, 15), c.yellow1, 0.3)
  local GREEN = ds.color.blend(ds.color.lighten(c.green3, 30), c.cyan1, 0.2)
  local BLUE = ds.color.blend(ds.color.lighten(c.blue1, 10), c.aqua1, 0.25)
  local INDIGO = ds.color.blend(ds.color.lighten(c.blue1, 10), c.purple1, 0.4)
  local VIOLET = ds.color.blend(ds.color.lighten(c.magenta2, 25), c.purple2, 0.3)

  -- stylua: ignore
  return {
    RenderMarkdownBullet     = { link = "@markup.list"},

    RenderMarkdownH1         = { fg = c.bg2 },
    RenderMarkdownH1Bg       = { fg = c.bg2, bg = BLUE },
    RenderMarkdownH2         = { fg = c.bg2 },
    RenderMarkdownH2Bg       = { fg = c.bg2, bg = INDIGO },
    RenderMarkdownH3         = { fg = c.bg2 },
    RenderMarkdownH3Bg       = { fg = c.bg2, bg = VIOLET },
    RenderMarkdownH4         = { fg = c.bg2 },
    RenderMarkdownH4Bg       = { fg = c.bg2, bg = RED },
    RenderMarkdownH5         = { fg = c.bg2 },
    RenderMarkdownH5Bg       = { fg = c.bg2, bg = ORANGE },
    RenderMarkdownH6         = { fg = c.bg2 },
    RenderMarkdownH6Bg       = { fg = c.bg2, bg = GREEN },

    -- `NormalFloat` overrides
    NormalFloatH1            = { fg = c.bg0 },
    NormalFloatH1Bg          = { fg = c.bg0, bg = BLUE },
    NormalFloatH2            = { fg = c.bg0 },
    NormalFloatH2Bg          = { fg = c.bg0, bg = INDIGO },
    NormalFloatH3            = { fg = c.bg0 },
    NormalFloatH3Bg          = { fg = c.bg0, bg = VIOLET },
    NormalFloatH4            = { fg = c.bg0 },
    NormalFloatH4Bg          = { fg = c.bg0, bg = RED },
    NormalFloatH5            = { fg = c.bg0 },
    NormalFloatH5Bg          = { fg = c.bg0, bg = ORANGE },
    NormalFloatH6            = { fg = c.bg0 },
    NormalFloatH6Bg          = { fg = c.bg0, bg = GREEN },

    RenderMarkdownCodeBorder = { bg = ds.color.darken(c.blue1, 65), bold = true },
  }
end

return M
