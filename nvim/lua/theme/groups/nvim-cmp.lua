local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local BLUE = ds.color.lighten(c.blue2, 15)
  local BLUE_DARK = ds.color.darken(c.blue2, 35)
  -- stylua: ignore
  return {
    CmpGhostText                 = { link = "Comment" },

    CmpItemAbbr                  = { fg = c.white },
    CmpItemAbbrDeprecated        = { fg = c.white },
    CmpItemAbbrMatch             = { fg = BLUE, bold = true },
    CmpItemAbbrMatchFuzzy        = { fg = c.orange0, bold = true },

    CmpItemKindCopilot           = { fg = c.green0 },
    CmpItemKindDefault           = { fg = c.white },

    CmpItemKindClass             = { link = "@lsp.type.class" },
    CmpItemKindConstant          = { link = "@constant" },
    CmpItemKindConstructor       = { link = "@constructor" },
    CmpItemKindEnum              = { link = "@lsp.type.enum" },
    CmpItemKindEnumMember        = { link = "@lsp.type.enumMember" },
    CmpItemKindEvent             = { link = "@boolean" },
    CmpItemKindField             = { link = "@variable.member" },
    CmpItemKindFile              = { link = "Directory" },
    CmpItemKindFolder            = { link = "Directory" },
    CmpItemKindFunction          = { link = "@lsp.type.function" },
    CmpItemKindInterface         = { link = "@lsp.type.interface" },
    CmpItemKindKeyword           = { link = "@keyword" },
    CmpItemKindMethod            = { link = "@lsp.type.method" },
    CmpItemKindModule            = { link = "@module" },
    CmpItemKindOperator          = { link = "@operator" },
    CmpItemKindProperty          = { link = "@property" },
    CmpItemKindReference         = { link = "@markup.link" },
    CmpItemKindSnippet           = { fg = c.purple0 },
    CmpItemKindStruct            = { link = "@lsp.type.struct" },
    CmpItemKindText              = { link = "@markup.raw" },
    CmpItemKindTypeParameter     = { link = "@lsp.type.parameter" },
    CmpItemKindUnit              = { link = "SpecialChar" },
    CmpItemKindValue             = { link = "@markup" },
    CmpItemKindVariable          = { link = "@property" },

    CmpItemMenu                  = { fg = BLUE_DARK },
  }
end

return M