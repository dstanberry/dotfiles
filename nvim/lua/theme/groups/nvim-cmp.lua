local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  local BLUE = ds.color.lighten(c.blue2, 15)
  local BLUE_DARK = ds.color.darken(c.blue2, 35)
  -- stylua: ignore
  local groups = {
    CmpGhostText                 = { link = "Comment" },
    CmpItemAbbrDefault           = { fg = c.white },
    CmpItemAbbrDeprecatedDefault = { fg = c.white },
    CmpItemAbbrMatchDefault      = { fg = BLUE, bold = true },
    CmpItemAbbrMatchFuzzyDefault = { fg = c.orange0, bold = true },
    CmpItemMenu                  = { fg = BLUE_DARK },

    CmpItemKindClass             = { link = "@lsp.type.class" },
    CmpItemKindConstant          = { link = "@constant" },
    CmpItemKindConstructor       = { link = "@constructor" },
    CmpItemKindCopilot           = { fg = c.green0 },
    CmpItemKindDefault           = { fg = c.white },
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
    CmpItemMenuDefault           = { link = "@property" },
  }
  -- cmp highlights won't apply until after the plugin is loaded
  ds.plugin.on_load("nvim-cmp", function() ds.hl.set(groups) end)
  -- cmp could clear one or more of these highlight groups when the colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = ds.hl.autocmd_group,
    callback = function() ds.hl.set(groups) end,
  })
  return groups
end

return M
