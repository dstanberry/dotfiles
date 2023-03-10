return function()
  if vim.bo.expandtab then
    return ("spaces: %s"):format(vim.bo.shiftwidth)
  else
    return ("tabs: %s"):format(vim.bo.tabstop)
  end
end
