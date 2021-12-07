local util = require "util"

local nnoremap = util.map.nnoremap
local inoremap = util.map.inoremap

local M = {}

M.border_line = "─"

M.calculate_width = function(lines)
  local max_width = math.ceil(vim.o.columns * 0.8)
  local max_length = 0
  for _, line in pairs(lines) do
    if #line > max_length then
      max_length = #line
    end
  end
  return max_length <= max_width and max_length or max_width
end

M.popup_window = function(opts)
  local lines, syntax = opts.lines or {}, opts.syntax
  opts.border = opts.border or "rounded"
  local bufnr, winnr = vim.lsp.util.open_floating_preview(lines, syntax, opts)
  -- vim.api.nvim_win_set_option(winnr, "winhl", "Normal:Normal")
  if opts.enter then
    vim.api.nvim_set_current_win(winnr)
    inoremap("jk", function()
      vim.cmd [[stopinsert]]
      vim.api.nvim_win_close(0, true)
    end, { buffer = bufnr })
    nnoremap("<esc>", function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = bufnr })
    nnoremap("q", function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = bufnr })
  end
  if opts.on_confirm then
    inoremap("<cr>", function()
      opts.on_confirm()
      vim.cmd [[stopinsert]]
    end, { buffer = bufnr })
    nnoremap("<cr>", function()
      opts.on_confirm()
    end, { buffer = bufnr })
  end
  if opts.input then
    vim.schedule(function()
      vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
      vim.cmd [[startinsert]]
    end)
  end
  if opts.prompt and opts.prompt.enable then
    vim.api.nvim_buf_set_option(bufnr, "buftype", "prompt")
    vim.fn.prompt_setprompt(bufnr, opts.prompt.prefix)
    vim.api.nvim_buf_add_highlight(bufnr, -1, opts.prompt.highlight, #lines, 0, #opts.prompt.prefix)
    vim.api.nvim_buf_set_option(bufnr, "ft", "UIPrompt")
  end
  if opts.set_cursor then
    vim.api.nvim_win_set_cursor(winnr, { 3, 1 })
    util.define_augroup {
      name = "update_cursor",
      clear = true,
      autocmds = {
        {
          event = "CursorMoved",
          callback = function()
            local current_line = vim.fn.line "."
            local max_lines = vim.api.nvim_buf_line_count(0)
            if current_line < 3 and max_lines >= 3 then
              vim.api.nvim_win_set_cursor(0, { 3, 1 })
            end
          end,
        },
      },
    }
  end
  return bufnr, winnr
end

return M
