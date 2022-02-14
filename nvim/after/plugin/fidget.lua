-- verify fidget is available
local ok, fidget = pcall(require, "fidget")
if not ok then
  return
end

fidget.setup {
  text = {
    spinner = "dots_snake",
  },
  align = {
    bottom = true,
    right = true,
  },
}
