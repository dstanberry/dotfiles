-- verify buftabline is available
local ok, tabline = pcall(require, "buftabline")
if not ok then
  return
end

tabline.setup {
  tab_format = " #{i} #{b}#{f} ",
  disable_commands = true,
  icons = true,
  go_to_maps = false,
  start_hidden = false,
  flags = {
    modified = "●",
    not_modifiable = "",
    readonly = "",
  },
  show_tabpages = false,
}
