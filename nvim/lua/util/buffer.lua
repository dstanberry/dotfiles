local M = {}

function M.create_scratch_buffer()
  local ft = vim.fn.input "scratch buffer filetype: "
  vim.fn.execute "20new [Scratch]"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  if ft then
    vim.bo.filetype = ft
  end
end

function M.create_md_note()
  local dir = vim.env.hash_n or vim.env.HOME
  local fname = ("%s/%s.md"):format(dir, os.date "%m_%d_%y")
  vim.fn.execute(("edit %s"):format(fname))
  local bufnr = vim.fn.bufnr(vim.fn.expand(("%s"):format(fname), true))
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local open_bufnr = vim.api.nvim_win_get_buf(win_id)
    if open_bufnr == bufnr then
      return vim.api.nvim_set_current_win(win_id)
    end
  end
  vim.api.nvim_win_set_buf(0, bufnr)
end

return M
