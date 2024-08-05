local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- lsp semantic tokens
    ["@lsp.type.boolean"]                      = { link = "@boolean" },
    ["@lsp.type.builtinType"]                  = { link = "@type.builtin" },
    ["@lsp.type.class"]                        = { link = "@class" },
    ["@lsp.type.comment"]                      = { link = "@comment" },
    ["@lsp.type.decorator"]                    = { link = "@constant.macro" },
    ["@lsp.type.deriveHelper"]                 = { link = "@attribute" },
    ["@lsp.type.enum"]                         = { link = "@constructor" },
    ["@lsp.type.enumMember"]                   = { link = "@constant" },
    ["@lsp.type.escapeSequence"]               = { link = "@string.escape" },
    ["@lsp.type.event"]                        = { link = "Identifier" },
    ["@lsp.type.formatSpecifier"]              = { link = "@markup.list" },
    ["@lsp.type.function"]                     = { link = "@function" },
    ["@lsp.type.generic"]                      = { link = "@variable" },
    ["@lsp.type.interface"]                    = { fg = ds.color.lighten(c.cyan1, 20), bold = true },
    ["@lsp.type.lifetime"]                     = { link = "@keyword.storage" },
    ["@lsp.type.method"]                       = { link = "@function.method" },
    ["@lsp.type.modifier"]                     = { link = "Identifier" },
    ["@lsp.type.namespace"]                    = { link = "@module" },
    ["@lsp.type.number"]                       = { link = "@number" },
    ["@lsp.type.operator"]                     = { link = "@operator" },
    ["@lsp.type.parameter"]                    = { link = "@variable.parameter" },
    ["@lsp.type.property"]                     = { link = "@property" },
    ["@lsp.type.regexp"]                       = { link = "@string.regexp" },
    ["@lsp.type.selfKeyword"]                  = { link = "@variable.builtin" },
    ["@lsp.type.selfTypeKeyword"]              = { link = "@variable.builtin" },
    ["@lsp.type.string"]                       = { link = "@string" },
    ["@lsp.type.struct"]                       = { link = "@structure" },
    ["@lsp.type.type"]                         = { link = "@type" },
    ["@lsp.type.typeAlias"]                    = { link = "@type.definition" },
    ["@lsp.type.typeParameter"]                = { link = "@lsp.type.class" },
    ["@lsp.type.unresolvedReference"]          = { link = "DiagnosticUnderlineError" },
    ["@lsp.type.variable"]                     = {}, -- fallback to treesitter

    -- lsp semantic modifier tokens
    ["@lsp.typemod.class.defaultLibrary"]      = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"]   = { link = "@function.builtin" },
    ["@lsp.typemod.keyword.async"]             = { link = "@keyword.coroutine" },
    ["@lsp.typemod.keyword.injected"]          = { link = "@keyword" },
    ["@lsp.typemod.macro.defaultLibrary"]      = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"]     = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"]         = { link = "@operator" },
    ["@lsp.typemod.string.injected"]           = { link = "@string" },
    ["@lsp.typemod.struct.defaultLibrary"]     = { link = "@type.builtin" },
    ["@lsp.typemod.type.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.typeAlias.defaultLibrary"]  = { link = "@type.builtin" },
    ["@lsp.typemod.variable.callable"]         = { link = "@function" },
    ["@lsp.typemod.variable.defaultLibrary"]   = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"]         = { link = "@variable" },
    ["@lsp.typemod.variable.static"]           = { link = "@constant" }
  }
end

return M
