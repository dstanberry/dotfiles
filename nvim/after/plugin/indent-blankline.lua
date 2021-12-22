-- verify indent-blankline is available
local ok, indent_blankline = pcall(require, "indent_blankline")
if not ok then
  return
end

indent_blankline.setup {
  indentLine_enabled = 1,
  show_current_context = true,
  show_current_context_start = true,
  show_trailing_blankline_indent = false,
  space_char_blankline = " ",
  char_list = { "│", "┊" },
  buftype_exclude = { "terminal" },
  filetype = {
    "go",
    "html",
    "json",
    "python",
    "rust",
  },
}
