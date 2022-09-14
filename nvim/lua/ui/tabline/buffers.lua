local Buftab = require "ui.tabline.buftab"

local should_handle = function(bufnr)
  return vim.api.nvim_buf_get_option(bufnr, "buflisted") and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local getbufinfo = function()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local processed = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if should_handle(bufnr) then
      table.insert(processed, {
        bufnr = bufnr,
        name = vim.api.nvim_buf_get_name(bufnr),
        current = bufnr == current_bufnr,
        safe = bufnr <= current_bufnr,
        changed = vim.api.nvim_buf_get_option(bufnr, "modified"),
        modifiable = vim.api.nvim_buf_get_option(bufnr, "modifiable"),
        readonly = vim.api.nvim_buf_get_option(bufnr, "readonly"),
        active = vim.fn.bufwinnr(bufnr) > 0,
      })
    end
  end
  return processed
end

local M = {}

M.getbufinfo = getbufinfo

M.get_numbers = function()
  local numbers = {}
  for _, buf in ipairs(getbufinfo()) do
    table.insert(numbers, buf.bufnr)
  end
  return numbers
end

M.get_current_index = function()
  local current = vim.api.nvim_get_current_buf()
  for i, buf in ipairs(getbufinfo()) do
    if buf.bufnr == current then
      return i
    end
  end
end

M.make_buftabs = function()
  local bufinfo = getbufinfo()
  local buftabs = {}
  for i, buf in ipairs(bufinfo) do
    table.insert(buftabs, Buftab:new(buf, i, i == #bufinfo))
  end
  return buftabs
end

return M
