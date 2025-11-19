local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    BlinkCmpDocBorder         = { link = "FloatBorder" },
    BlinkCmpMenuBorder        = { link = "FloatBorder" },

    BlinkCmpGhostText         = { link = "Comment" },

    BlinkCmpLabel             = { fg = c.white },
    BlinkCmpLabelDeprecated   = { fg = c.red3 },
    BlinkCmpLabelMatch        = { bold = true },

    BlinkCmpKindCopilot       = { link = "Macro" },
    BlinkCmpKindDefault       = { fg = c.white },

    BlinkCmpKindClass         = { link = "@lsp.type.class" },
    BlinkCmpKindConstant      = { link = "@constant" },
    BlinkCmpKindConstructor   = { link = "@constructor" },
    BlinkCmpKindEnum          = { link = "@lsp.type.enum" },
    BlinkCmpKindEnumMember    = { link = "@lsp.type.enumMember" },
    BlinkCmpKindEvent         = { link = "@boolean" },
    BlinkCmpKindField         = { link = "@variable.member" },
    BlinkCmpKindFile          = { link = "Directory" },
    BlinkCmpKindFolder        = { link = "Directory" },
    BlinkCmpKindFunction      = { link = "@lsp.type.function" },
    BlinkCmpKindInterface     = { link = "@lsp.type.interface" },
    BlinkCmpKindKeyword       = { link = "@keyword" },
    BlinkCmpKindMethod        = { link = "@lsp.type.method" },
    BlinkCmpKindModule        = { link = "@module" },
    BlinkCmpKindOperator      = { link = "@operator" },
    BlinkCmpKindProperty      = { link = "@property" },
    BlinkCmpKindReference     = { link = "@markup.link" },
    BlinkCmpKindSnippet       = { link = "Conceal" },
    BlinkCmpKindStruct        = { link = "@lsp.type.struct" },
    BlinkCmpKindText          = { link = "@markup.raw" },
    BlinkCmpKindTypeParameter = { link = "@lsp.type.parameter" },
    BlinkCmpKindUnit          = { link = "SpecialChar" },
    BlinkCmpKindValue         = { link = "@markup" },
    BlinkCmpKindVariable      = { link = "@property" },
  }
end

return M
