---@class remote.snacks.util.indent
local M = {}

M.config = {
  indent = {
    blank = "·",
    char = ds.icons.misc.VerticalBarThin,
    hl = "NonText",
  },
  scope = {
    char = ds.icons.misc.VerticalBar,
    underline = true,
    hl = vim.tbl_map(function(i) return "SnacksIndent" .. i end, vim.fn.range(1, 8)),
  },
  filter = function(buf)
    local filetypes = ds.extend(
      ds.excludes.ft.stl_disabled,
      ds.excludes.ft.wb_disabled,
      ds.excludes.ft.wb_empty,
      { "checkhealth", "diff", "git" },
      { "log", "markdown", "txt" }
    )
    if vim.tbl_contains(filetypes, vim.bo[buf].filetype) then vim.b[buf].snacks_indent = false end
    return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
  end,
}

return M
