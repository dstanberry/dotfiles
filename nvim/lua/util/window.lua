local M = {}

M.separator = "─"

---@param lines integer
---@return integer width
function M.calculate_width(lines)
  local max_width = math.ceil(vim.o.columns * 0.8)
  local max_length = 0
  for _, line in pairs(lines) do
    if #line > max_length then max_length = #line end
  end
  return max_length <= max_width and max_length or max_width
end

---Create a floating window containing a list of options to choose from
---@param opts table
---@return integer bufnr, integer winid
function M.popup_window(opts)
  local lines, syntax = opts.lines or {}, opts.syntax
  opts.border = opts.border or "rounded"
  local bufnr, winnr = vim.lsp.util.open_floating_preview(lines, syntax, opts)
  vim.api.nvim_win_set_option(winnr, "winhl", "Normal:Normal")
  if opts.enter then
    vim.api.nvim_set_current_win(winnr)
    vim.keymap.set("i", "jk", function()
      vim.cmd.stopinsert()
      vim.api.nvim_win_close(0, true)
    end, { buffer = bufnr })
    vim.keymap.set("n", "<esc>", function() vim.api.nvim_win_close(0, true) end, { buffer = bufnr })
    vim.keymap.set("n", "q", function() vim.api.nvim_win_close(0, true) end, { buffer = bufnr })
  end
  if opts.on_confirm then
    vim.keymap.set("i", "<cr>", function()
      opts.on_confirm()
      vim.cmd.stopinsert()
    end, { buffer = bufnr })
    vim.keymap.set("n", "<cr>", function() opts.on_confirm() end, { buffer = bufnr })
  end
  if opts.input then
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    vim.cmd.startinsert()
  end
  if opts.prompt and opts.prompt.enable then
    vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
    vim.fn.prompt_setprompt(bufnr, opts.prompt.prefix)
    vim.api.nvim_buf_set_option(bufnr, "ft", "UIPrompt")
    vim.defer_fn(
      function() vim.api.nvim_buf_add_highlight(bufnr, -1, opts.prompt.highlight, #lines, 0, #opts.prompt.prefix) end,
      50
    )
  end
  if opts.set_cursor then
    vim.api.nvim_win_set_cursor(winnr, { 3, 1 })
    local update_cursor = vim.api.nvim_create_augroup("update_cursor", { clear = true })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = update_cursor,
      callback = function()
        local current_line = vim.fn.line "."
        local max_lines = vim.api.nvim_buf_line_count(0)
        if current_line < 3 and max_lines >= 3 then vim.api.nvim_win_set_cursor(0, { 3, 1 }) end
      end,
    })
  end
  return bufnr, winnr
end

return M
