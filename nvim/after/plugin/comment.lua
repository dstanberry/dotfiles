-- verify Comment is available
local ok, comment = pcall(require, "Comment")
if not ok then
  return
end

comment.setup {
  padding = true,
  sticky = true,
  mappings = {
    basic = true,
    extra = true,
    extended = true,
  },
  toggler = {
    line = "gcc",
    block = "gac",
  },
  opleader = {
    line = "gc",
    block = "ga",
  },
}
