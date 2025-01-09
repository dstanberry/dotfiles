local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    RenderMarkdownH1Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.55) },
    RenderMarkdownH2Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.5) },
    RenderMarkdownH3Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.4) },
    RenderMarkdownH4Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.3) },
    RenderMarkdownH5Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.2) },
    RenderMarkdownH6Bg = { bg = ds.color.blend(c.blue0, c.bg2, 0.15) }
  }
end

return M
