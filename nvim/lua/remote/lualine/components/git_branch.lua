return function()
  local icon = ds.pad(ds.icons.git.Branch, "right")
  if package.loaded["gitsigns"] then
    ---@diagnostic disable-next-line: undefined-field
    local branch = vim.b.gitsigns_head
    if not branch or #branch == 0 then return ds.pad(ds.icons.misc.Orbit, "right") end
    return icon .. branch
  end
  return ds.pad(ds.icons.misc.Orbit, "right")
end
