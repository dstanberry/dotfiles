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
  pre_hook = function(ctx)
    local cutils = require "Comment.utils"
    local ts = require "ts_context_commentstring.internal"
    local type = ctx.ctype == cutils.ctype.line and "__default" or "__multiline"
    return pcall(ts.calculate_commentstring { key = type })
  end,
}
