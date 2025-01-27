local M = {}

---@param buf number
---@param bo vim.bo
M.bo = function(buf, bo)
  for k, v in pairs(bo or {}) do
    vim.api.nvim_set_option_value(k, v, { buf = buf })
  end
end

---@param win number
---@param wo vim.wo
M.wo = function(win, wo)
  for k, v in pairs(wo or {}) do
    vim.api.nvim_set_option_value(k, v, { win = win, scope = "local" })
  end
end

---@param buf number
---@param opts? table
M.setup = function(buf, opts)
  buf = buf or vim.api.nvim_get_current_buf()
  opts = vim.tbl_deep_extend("force", require("ft.config")[vim.bo[buf].filetype or ""] or {}, opts or {})

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    opts = vim.tbl_deep_extend("force", opts, {
      wo = { relativenumber = vim.b[buf].ts_highlight or (ok and parser ~= nil) },
    })
    M.wo(win, opts.wo)
  end

  M.bo(buf, opts.bo)
end

return M
