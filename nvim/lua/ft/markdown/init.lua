local M = {}

M.insert_checkbox = function() vim.api.nvim_put({ "[ ] " }, "c", true, true) end

M.insert_link = function()
  local url = vim.fn.getreg "*"
  local link = string.format("[](%s)", url)
  local cursor = vim.fn.getpos "."
  vim.api.nvim_put({ link }, "c", true, true)
  vim.fn.setpos(".", { cursor[1], cursor[2], cursor[3] + 1, cursor[4] })
end

local get_lines = function()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  return line_start, line_end, vim.fn.getline(line_start, line_end)
end

M.toggle_bullet = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^%s*%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
  require("ft.markdown.concealer").toggle_on()
end

M.toggle_checkbox = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^(%s*)%-%s%[%s%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[%s%]%s", "%1- [x] ")))
    elseif string.match(line, "^(%s*)%-%s%[x%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[x%]%s", "%1- ")))
    elseif string.match(line, "^(%s*)%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1- [ ] ")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- [ ] ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
  require("ft.markdown.concealer").toggle_on()
end

return setmetatable({}, {
  __index = function(t, k)
    if M[k] then
      return M[k]
    else
      local ok, val = pcall(require, string.format("ft.markdown.%s", k))
      if ok then
        rawset(t, k, val)
        return val
      end
    end
  end,
})
