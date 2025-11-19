local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    -- lsp semantic tokens
    ["@lsp.type.decorator"]                    = { link = "@attribute" },
    ["@lsp.type.enum"]                         = { link = "@type" },
    ["@lsp.type.interface"]                    = { fg = ds.color.blend(c.blue3, "#ffffff", 0.7) },
    ["@lsp.type.keyword"]                      = { link = "@keyword" },
    ["@lsp.type.namespace.python"]             = { link = "@variable" },
    ["@lsp.type.unresolvedReference"]          = { undercurl = true, sp = c.red2 },

    -- lsp semantic modifier tokens
    ["@lsp.typemod.type.defaultLibrary"]       = { fg = ds.color.blend(c.aqua1, "#000000", 0.8) },
    ["@lsp.typemod.typeAlias.defaultLibrary"]  = { fg = ds.color.blend(c.aqua1, "#000000", 0.8) }
  }
end

return M
