local M = {}

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

function M.create_augroup(groups, clear)
  local start = clear or "autocmd!"
  for group_name, autocmd in pairs(groups) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command(start)
    for _, def in ipairs(autocmd) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command "augroup END"
  end
end

return M
