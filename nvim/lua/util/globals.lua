_G.dump = function(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

_G.dump_text = function(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, "\n"), "\n")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

_G.fold_text = function()
  local indent = vim.fn.indent(vim.v.foldstart - 1)
  local indent_level = vim.fn["repeat"](" ", indent)
  local line_count = string.format("%s lines", (vim.v.foldend - vim.v.foldstart + 1))
  local header = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]:gsub(" *", "", 1)
  local width = vim.fn.winwidth(0) - vim.wo.foldcolumn - (vim.wo.number and 8 or 0)
  local lhs = string.format("%s%s", indent_level, header)
  local rhs = string.format("%s  · %s", vim.v.foldlevel, line_count)
  local separator = vim.fn["repeat"](" ", width - vim.fn.strwidth(lhs) - vim.fn.strwidth(rhs))
  return string.format("%s %s%s ", lhs, separator, rhs)
end

_G.fold_expr = function(lnum)
  if string.find(vim.fn.getline(lnum), "%S") == nil then
    return "-1"
  end
  local get_indent_level = function(n)
    return vim.fn.indent(n) / vim.bo.shiftwidth
  end
  local get_next_line_with_content = function()
    local count = vim.fn.line "$"
    local line = lnum + 1
    while line <= count do
      if string.find(vim.fn.getline(line), "%S") ~= nil then
        return line
      end
      line = line + 1
    end
    return -2
  end
  local current = get_indent_level(lnum)
  local next = get_indent_level(get_next_line_with_content())
  if next <= current then
    return current
  end
  return ">" .. next
end

_G.has = function(feature)
  return vim.fn.has(feature) > 0
end

_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error("Command failed: " .. tostring(ok) .. " " .. vim.inspect { cmd = cmd, args = args })
    end
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

_G.reload = require("util").reload
