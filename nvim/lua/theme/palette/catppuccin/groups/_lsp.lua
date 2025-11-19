local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    -- lsp semantic tokens
    ["@lsp.type.enumMember"]                 = { fg = c.cyan1 },
    ["@lsp.type.variable"]                   = {},

    -- lsp semantic modifier tokens
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.function.builtin"]        = { link = "@function.builtin" },
  }
end

return M
