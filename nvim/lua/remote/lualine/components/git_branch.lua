local icons = require "ui.icons"

return function()
  local icon = pad(icons.git.Branch, "right")
  if package.loaded["gitsigns"] then
    ---@diagnostic disable-next-line: undefined-field
    local branch = vim.b.gitsigns_head
    if not branch or #branch == 0 then return pad(icons.misc.Orbit, "right") end
    return icon .. branch
  end
  return pad(icons.misc.Orbit, "right")
end
