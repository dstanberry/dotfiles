local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  local RED = ds.color.blend(ds.color.lighten(c.red2, 20), c.red1, 0.7)
  local ORANGE = ds.color.blend(ds.color.lighten(c.orange1, 15), c.yellow1, 0.3)
  local GREEN = ds.color.blend(ds.color.lighten(c.green3, 30), c.cyan1, 0.2)
  local BLUE = ds.color.blend(ds.color.lighten(c.blue1, 10), c.aqua1, 0.25)
  local INDIGO = ds.color.blend(ds.color.lighten(c.blue1, 10), c.purple1, 0.4)
  local VIOLET = ds.color.blend(ds.color.lighten(c.magenta2, 25), c.purple2, 0.3)

  -- stylua: ignore
  return {
    RenderMarkdownBullet     = { link = "@markup.list"},

    RenderMarkdownH1         = { fg = BLUE, bold = true },
    RenderMarkdownH1Bg       = { bg = ds.color.blend(ds.color.darken(BLUE, 50), c.bg2, 0.3) },
    RenderMarkdownH2         = { fg = INDIGO, bold = true },
    RenderMarkdownH2Bg       = { bg = ds.color.blend(ds.color.darken(INDIGO, 50), c.bg2, 0.3) },
    RenderMarkdownH3         = { fg = VIOLET, bold = true },
    RenderMarkdownH3Bg       = { bg = ds.color.blend(ds.color.darken(VIOLET, 50), c.bg2, 0.3) },
    RenderMarkdownH4         = { fg = RED, bold = true  },
    RenderMarkdownH4Bg       = { bg = ds.color.blend(ds.color.darken(RED, 50), c.bg2, 0.3) },
    RenderMarkdownH5         = { fg = ORANGE, bold = true  },
    RenderMarkdownH5Bg       = { bg = ds.color.blend(ds.color.darken(ORANGE, 50), c.bg2, 0.3) },
    RenderMarkdownH6         = { fg = GREEN, bold = true  },
    RenderMarkdownH6Bg       = { bg = ds.color.blend(ds.color.darken(GREEN, 50), c.bg2, 0.3) },

    RenderMarkdownCodeBorder = { bg = ds.color.darken(c.blue1, 65), bold = true },
  }
end

return M
