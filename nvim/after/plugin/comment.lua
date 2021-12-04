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
  opleader = {
    line = "gc",
    block = "gb",
  },
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  pre_hook = nil,
  post_hook = nil,
}
